class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show follow unfollow]

  def show; end

  def follow
    current_user.follows.create(follow_user_id: @user.id)
    redirect_to root_url, notice: "#{@user.name} をフォローしました。"
  end

  def unfollow
    current_user.follows.find_by(follow_user_id: @user.id).try(:destroy)
    redirect_to root_url, notice: "#{@user.name} のフォローを解除しました。"
  end

  private

    def set_user
      @user = User.find(params[:id])
    end
end
