class ProjectsController < ApplicationController
  before_action :is_user_logged_in
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :is_user_verified, only: [:new, :edit, :update, :destroy, :manage, :addUserToProject, :removeUserFromProject]
  before_action :is_user_authorized, only: [:edit, :update, :destroy, :manage, :addUserToProject, :removeUserFromProject]
  skip_before_action :verify_authenticity_token, only: [:addUserToProject , :removeUserFromProject]

  # GET /projects
  # GET /projects.json
  def index
    if current_user.user_type == 0
      @projects = Project.where( manager_id: current_user.id )
    elsif current_user.user_type == 1
      @projects = Project.joins("INNER JOIN project_users ON project_users.project_id = projects.id AND project_users.user_id = '"+current_user.id.to_s+"'")
    elsif current_user.user_type == 2
      @projects = Project.all
    end
  end

  def index_old
    if current_user.user_type == 0
      @projects = Project.where( manager_id: current_user.id )
    elsif current_user.user_type == 1
      developer_index
    elsif current_user.user_type == 2
      qa_index
    end
  end

  def developer_index
  end

  def developer_index
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    check_project_id
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  def addUserToProject
    projectId = params[:projectId]
    userId = params[:userId]
    id = params[:id]
    if id != projectId
      render json: { code: false, reason: "Invalid request." }
    elsif Project.find(id).manager_id != current_user.id
      render json: { code: false, reason: "Invalid request." }
    elsif ProjectUser.where(project_id: projectId, user_id: userId).exists?
      render json: { code: false, reason: "This user is already added to this project." }
    else
      p = ProjectUser.new
      p.project_id = projectId
      p.user_id = userId
      p.save
      if p.valid?
        render json: { code: true, reason: "User added successfully." }
      else
        render json: { code: false, reason: "Something went wrong. Please try again." }
      end
    end
  end


  def removeUserFromProject
    projectId = params[:projectId]
    userId = params[:userId]
    id = params[:id]
    if id != projectId
      render json: { code: false, reason: "Invalid request." }
    elsif Project.find(id).manager_id != current_user.id
      render json: { code: false, reason: "Invalid request." }
    else
      ProjectUser.where(project_id: projectId, user_id: userId).delete_all
      if ProjectUser.where(project_id: projectId, user_id: userId).exists?
        render json: { code: false, reason: "Something went wrong. Please try again." }
      else
        render json: { code: true, reason: "User removed successfully."}
      end
    end
  end


  def manage
    id =  to_number(params[:id])
    if id < 1
      redirect_to projects_url
    end
    @developers = User.joins("INNER JOIN project_users ON project_users.user_id = users.id AND users.user_type='1' AND project_users.project_id = '"+id.to_s+"'")
    @qas = User.joins("INNER JOIN project_users ON project_users.user_id = users.id AND users.user_type='2' AND project_users.project_id = '"+id.to_s+"'")
  end

  #Converts a string to number appropriately
  def to_number(string)
    Integer(string || '')
  rescue ArgumentError
    0
  end
  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.manager_id = current_user.id
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

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
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

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    ProjectUser.where(project_id: @project.id).delete_all
    Bug.where(project_id: @project.id).delete_all
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def check_project_id
      @project_id = to_number(params[:id])
      if @project_id < 1
        redirect_to projects_url
      elsif !ProjectUser.where(project_id: @project_id, user_id: current_user.id).exists?
        redirect_to projects_url
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :start_date)
    end

    def is_user_verified
      if current_user.user_type != 0
        redirect_to projects_url, notice: 'You do not have access to create new projects.'
      end
    end

    def is_user_authorized
      if Project.find(params[:id]).manager_id != current_user.id
        redirect_to projects_url, notice: 'You do not have access to this projects.'
      end
    end

    def is_user_logged_in
      unless user_signed_in?
        redirect_to new_user_session_path
      end
    end
end
