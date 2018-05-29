class BugsController < ApplicationController
  before_action :is_user_logged_in
  before_action :set_bug, only: [:show, :edit, :update, :destroy]
  before_action :check_project_id, only: [:allBugs, :newBugs, :myBugs]
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
    @bugs = Bug.where(project_id: @project_id)
  end

  def newBugs
    @bugs = Bug.where(project_id: @project_id , developer_id: nil)
  end

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

  def myBugs
    @bugs = Bug.where(project_id: @project_id , developer_id: current_user.id)
  end


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



  # GET /bugs/1
  # GET /bugs/1.json
  def show
    is_user_authorized
  end

#  def isAllowedToSee
#    bugId = params[:id]
#    if bugId < 1
#      redirect_to projects_url
#    end
#    @bug = Bug.find(bugId)
#    if current_user.user_type = 0
#      if @bug.project_id
#  end

  # GET /bugs/new
  def new
    @bug = Bug.new
  end

  # GET /bugs/1/edit
  def edit
  end

  # POST /bugs
  # POST /bugs.json
  def create
    @bug = Bug.new(bug_params)
    @bug.creator_id = current_user.id
    @bug.project_id = params[:id]
    @bug.status = 0

    respond_to do |format|
      if @bug.save
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
  # PATCH/PUT /bugs/1
  # PATCH/PUT /bugs/1.json
  def update
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

  # DELETE /bugs/1
  # DELETE /bugs/1.json
  def destroy
    @bug.destroy
    respond_to do |format|
      format.html { redirect_to bugs_url, notice: 'Bug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def check_project_id
      @project_id = to_number(params[:id])
      if @project_id < 1
        redirect_to projects_url
      else
        if current_user.user_type == 0
          unless Project.where(id: @project_id, manager_id: current_user.id).exists?
            redirect_to projects_url
          end
        elsif current_user.user_type == 1
          if !ProjectUser.where(project_id: @project_id, user_id: current_user.id).exists?
            redirect_to projects_url
          end
        end
      end
    end

    def to_number(string)
      Integer(string || '')
    rescue ArgumentError
      0
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_bug
      if Bug.where(id: params[:id]).exists?
        @bug = Bug.find(params[:id])
      else
        redirect_to "/my-bugs", notice: 'This bug does not exists.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bug_params
      params.require(:bug).permit(:title, :deadline, :issue_type, :status, :bug_image)
    end


    def is_user_verified
      if current_user.user_type != 2
        redirect_to projects_url, notice: 'You do not have access to create new bugs/features.'
      end
    end

    def is_user_authorized
      if current_user.user_type == 0 && Bug.find(params[:id]).project.manager_id != current_user.id
        redirect_to "/my-bugs", notice: 'You do not have access to this bug.' + Bug.find(params[:id]).project.manager_id.to_s
      elsif current_user.user_type == 1 && !ProjectUser.where(project_id: Bug.find(params[:id]).project.id, user_id: current_user.id).exists?
        redirect_to "/my-bugs", notice: 'You do not have access to this bug.'
      elsif current_user.user_type == 2 && Bug.find(params[:id]).creator_id != current_user.id
        redirect_to "/my-bugs", notice: 'You do not have access to this bug.'
      end
    end

    def is_user_logged_in
      unless user_signed_in?
        redirect_to new_user_session_path
      end
    end
end
