class UsersController < ApplicationController
  def index
    redirect_to projects_url
  end

  def search
    authorize User
    name = params[:name]
    params = {:search_user => name}
    @users = User.filter(params)
    render json: { code: true, reason: "Results successful.", data: @users }
  end
end
