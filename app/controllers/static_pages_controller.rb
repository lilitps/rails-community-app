class StaticPagesController < ApplicationController
  def home
    @posts = Post.all.paginate(page: params[:page], per_page: 5)
  end

  def about
  end

  def contact
  end

  def help
  end
end
