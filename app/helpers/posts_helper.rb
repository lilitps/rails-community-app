module PostsHelper
  # Returns 5 posts per page
  def feed(page, per_page = 5, only_admin = true)
    Post.includes(:user).where(users: {admin: only_admin}).paginate(page: page, per_page: per_page)
  end
end
