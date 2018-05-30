class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end
  def search?
    @current_user.user_type == 0
  end
end
