class BugsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bug, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create , :assignBug , :markBug]
  # GET /bugs
  # GET /bugs.json
  def index
    if current_user.user_type == 0
      goToProjectsIndex
    elsif current_user.user_type == 1
      @bugs = Bug.where( developer_id: current_user.id )
    elsif  current_user.user_type == 2
      @bugs = @bugs = Bug.where( creator_id: current_user.id )
    end
  end

  def allBugs
    authorizeBug
    @bugs = Bug.where(project_id: @project_id)
  end

  def newBugs
    authorizeBug
    @bugs = Bug.where(project_id: @project_id , developer_id: nil)
  end

  def myBugs
    authorizeBug
    @bugs = Bug.where(project_id: @project_id , developer_id: current_user.id)
  end

  def show
    authorize @bug
  end

  def new
    @bug = Bug.new
    authorize @bug
  end

  def edit
    authorize @bug
  end

  def create
    @bug = Bug.new(bug_params)
    @bug.creator_id = current_user.id
    @bug.project_id = params[:id]
    @bug.status = 0

    #If a bug with same name exists in current project
    respond_to do |format|
      if Bug.where(project_id: params[:id] , title: @bug.title).exists?
        @bug.errors.add( :title , "must be unique throughout project")
        format.html { render :new }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      elsif @bug.save
        format.html { redirect_to @bug, notice: 'Bug was successfully created.' }
        format.json { render :show, status: :created, location: @bug }
      else
        format.html { render :new }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  def goToProjectsIndex
    redirect_to projects_url
  end

  def update
    authorize @bug
    respond_to do |format|
      if @bug.update(bug_params)
        format.html { redirect_to @bug, notice: 'Bug was successfully updated.' }
        format.json { render :show, status: :ok, location: @bug }
      else
        format.html { render :edit }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @bug
    @bug.destroy
    respond_to do |format|
      format.html { redirect_to bugs_url, notice: 'Bug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #POST REQUESTS

  #This Function is called by POST request to assign bug to a member
  def assignBug
    projectId = params[:projectId]
    bugId = to_number( params[:bugId] )
    userId = current_user.id
    id = params[:id]
    if id != projectId
      render json: { code: false, reason: "Invalid request." }
    elsif bugId < 0
      render json: { code: false, reason: "Invalid request." }
    elsif ProjectUser.where(project_id: projectId, user_id: userId).exists?
      bug = Bug.find(bugId)
      if bug.project_id == to_number(projectId) && bug.developer_id.nil?
        bug.developer_id = current_user.id
        bug.save
        if bug.valid?
          render json: { code: true, reason: "Bug assigned successfully." }
        else
          render json: { code: false, reason: "Something went wrong. Please try again." }
        end
      else
        render json: { code: false, reason: "This project is already assigned to a developer." }
      end
    else
      render json: { code: false, reason: "Invalid request." }
    end
  end


  #This Function is called by POST request to mark bug status
  def markBug
    projectId = params[:projectId]
    bugId = to_number( params[:bugId] )
    userId = current_user.id
    id = params[:id]
    if id != projectId
      render json: { code: false, reason: "Invalid request." }
    elsif bugId < 0
      render json: { code: false, reason: "Invalid request." }
    elsif ProjectUser.where(project_id: projectId, user_id: userId).exists?
      bug = Bug.find(bugId)
      if(bug.project_id == to_number(projectId) && bug.developer_id == current_user.id)
        if(bug.status == 0)
          bug.status = 1
        elsif bug.status == 1
          bug.status = 2
        end
        bug.save
        if bug.valid?
          render json: { code: true, reason: "Bug marked successfully." }
        else
          render json: { code: false, reason: "Something went wrong. Please try again." }
        end
      else
        render json: { code: false, reason: "Invalid request." }
      end
    else
      render json: { code: false, reason: "Invalid request." }
    end
  end

  private

    # This is the method that'll be called if Pundit un-authorizes the user
    def user_not_authorized
      redirect_to((request.referrer || root_path) ,notice: "Authorization error.")
    end

    #Converts a string to number appropriately
    def to_number(string)
      Integer(string || '')
      rescue ArgumentError
        0
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_bug
      @bug = Bug.where(id: params[:id])
      if @bug.exists?
        @bug = @bug.first
      else
        redirect_to "/my-bugs", notice: 'This bug does not exists.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bug_params
      params.require(:bug).permit(:title, :deadline, :issue_type, :status, :bug_image)
    end

    def authorizeBug
      @project_id = to_number(params[:id])
      bug = Bug.new
      bug.project_id = @project_id
      authorize bug
    end

end
