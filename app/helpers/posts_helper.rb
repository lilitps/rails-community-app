module PostsHelper
  include SessionsHelper

  # Returns 5 posts per page
  def feed(page, per_page = 5, only_admin = true)
    query = Post.joins(:user).where(users: {admin: only_admin})
    query = query.or(Post.joins(:user)
                         .where(users: {admin: !only_admin})
                         .where("user_id IN (?) OR user_id = ?", current_user.following_ids, current_user.id)) if logged_in?
    query.paginate(page: page, per_page: per_page)
  end
end
