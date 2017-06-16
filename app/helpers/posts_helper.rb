module PostsHelper
  include SessionsHelper

  # Returns 5 posts per page
  def feed(page, per_page = 5, only_admin = true)
    query = Post.includes(:user).where(users: {admin: only_admin})
    if logged_in?
      following_ids = "SELECT followed_id FROM relationships WHERE  follower_id = :user_id"
      query = query.or(Post.includes(:user)
                           .where(users: {admin: !only_admin})
                           .where("user_id IN (#{following_ids}) OR user_id = :user_id",
                                  user_id: current_user.id))
    end
    query.paginate(page: page, per_page: per_page)
  end
end
