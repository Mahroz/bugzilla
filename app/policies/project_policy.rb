class ProjectPolicy < ApplicationPolicy
  # initialize(user, resource)is inherited from ApplicationPolicy
  def initialize(user , project)
    @user = user
    @project = project
  end

  def show?
    isManager? || isProjectUser?
  end

  def new?
    isManager?
  end

  def manage?
    isManager? && isCurrentProjectManager?
  end

  def edit?
    isManager? && isCurrentProjectManager?
  end

  def create?
    isManager?
  end

  def update?
    isManager? && isCurrentProjectManager?
  end

  def destroy?
    isManager? && isCurrentProjectManager?
  end

  def addUserToProject?
    isManager? && isCurrentProjectManager?
  end

  def removeUserFromProject?
    isManager? && isCurrentProjectManager?
  end

  def isManager?
    @user.user_type == 0
  end

  def isCurrentProjectManager?
    @project.manager_id == @user.id
  end

  def isProjectUser?
    ProjectUser.where(project_id: @project.id, user_id: @user.id).exists?
  end

end
