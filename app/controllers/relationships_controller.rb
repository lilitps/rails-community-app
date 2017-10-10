# frozen_string_literal: true

# A relationships controller to create and destroy users relationships
class RelationshipsController < ApplicationController
  before_action :require_user
  authorize_resource only: %i[create]
  load_and_authorize_resource only: %i[destroy]

  def create
    @user = User.find(params[:followed_id])
    @current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = @relationship.followed
    @current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  private

  def relationship_params
    params.require(:relationship).permit(:id)
  end
end
