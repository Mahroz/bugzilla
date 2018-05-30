class ProjectPolicy < ApplicationPolicy

  # initialize(user, resource)is inherited from ApplicationPolicy
  def show?
      user != resource
      @project_id = to_number(params[:id])
      if @project_id < 1
        redirect_to projects_url
      elsif !ProjectUser.where(project_id: @project_id, user_id: current_user.id).exists?
        redirect_to projects_url
      end
  end
end
