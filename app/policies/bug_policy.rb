class BugPolicy < ApplicationPolicy

  # initialize(user, resource)is inherited from ApplicationPolicyturn false
  def initialize(user, bug)
    @user = user
    @bug = bug
  end
  def show?
      if @user.user_type == 0 && @bug.project.manager_id != @user.id
        return false
      elsif @user.user_type == 1 && !ProjectUser.where(project_id: @bug.project.id, user_id: @user.id).exists?
        return false
      elsif @user.user_type == 2 && @bug.creator_id != @user.id
        return false
      else
        return true
      end
  end

  def new?
    @user.user_type == 2
  end

  def allBugs?
    checkProjectId?
  end

  def myBugs?
    checkProjectId?
  end

  def newBugs?
    checkProjectId?
  end

  def edit?
    @bug.creator_id == @user.id
  end

  def update?
    @bug.creator_id == @user.id
  end

  def destroy?
    @bug.creator_id == @user.id
  end

#This method checks if a user can access bugs of a project
  def checkProjectId?
    project_id = @bug.project_id
    if @user.user_type == 0
      if !Project.where(id: project_id, manager_id: @user.id).exists?
        return false
      end
    elsif @user.user_type == 1
      if !ProjectUser.where(project_id: project_id, user_id: @user.id).exists?
        return false
      end
    end
    return true
  end
end
