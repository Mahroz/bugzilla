class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy, :manage, :addUserToProject , :removeUserFromProject]
  skip_before_action :verify_authenticity_token, only: [:addUserToProject , :removeUserFromProject]

  def index
    if current_user.user_type == 0
      @projects = Project.where( manager_id: current_user.id )
    elsif current_user.user_type == 1
      @projects = Project.joins("INNER JOIN project_users ON project_users.project_id = projects.id AND project_users.user_id = '"+current_user.id.to_s+"'")
    elsif current_user.user_type == 2
      @projects = Project.all
    end
  end

  def show
    authorize @project
  end

  # GET /projects/new
  def new
    @project = Project.new
    authorize @project
  end

  # GET /projects/1/edit
  def edit
    authorize @project
  end

  def manage
    authorize @project
    id = @project.id
    @developers = User.joins("INNER JOIN project_users ON project_users.user_id = users.id AND users.user_type='1' AND project_users.project_id = '"+id.to_s+"'")
    @qas = User.joins("INNER JOIN project_users ON project_users.user_id = users.id AND users.user_type='2' AND project_users.project_id = '"+id.to_s+"'")
  end

  def create
    @project = Project.new(project_params)
    @project.manager_id = current_user.id
    authorize @project
    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_url, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @project
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @project
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  #POST REQUESTS
  #This function is called to add users to a project
  def addUserToProject
    authorize @project
    @project_id = to_number(params[:projectId])
    userId = params[:userId]
    id = params[:id]
    if to_number(id) != @project_id
      render json: { code: false, reason: "Invalid request." }
    elsif Project.find(id).manager_id != current_user.id
      render json: { code: false, reason: "Invalid request." }
    elsif ProjectUser.where(project_id: @project_id, user_id: userId).exists?
      render json: { code: false, reason: "This user is already added to this project."}
    else
      p = ProjectUser.new
      p.project_id = @project_id
      p.user_id = userId
      p.save
      if p.valid?
        render json: { code: true, reason: "User added successfully." }
      else
        render json: { code: false, reason: "Something went wrong. Please try again." }
      end
    end
  end

  #This function is called to remove users from a project
  def removeUserFromProject
    authorize @project
    @project_id = to_number(params[:projectId])
    userId = params[:userId]
    id = params[:id]
    if to_number(id) != @project_id
      render json: { code: false, reason: "Invalid request." }
    elsif Project.find(id).manager_id != current_user.id
      render json: { code: false, reason: "Invalid request." }
    else
      ProjectUser.where(project_id: @project_id, user_id: userId).delete_all
      if ProjectUser.where(project_id: @project_id, user_id: userId).exists?
        render json: { code: false, reason: "Something went wrong. Please try again." }
      else
        render json: { code: true, reason: "User removed successfully."}
      end
    end
  end

  private

    #Converts a string to number appropriately
    def to_number(string)
      Integer(string || '')
      rescue ArgumentError
        0
    end
    # This is the method that'll be called if Pundit un-authorizes the user
    def user_not_authorized
      redirect_to((request.referrer || root_path) ,notice: "Authorization error.")
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.where(id: params[:id])
      if @project.exists?
        @project = @project.first
      else
        redirect_to projects_url, notice: 'This project does not exists.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :start_date)
    end
end
