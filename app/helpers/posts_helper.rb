module PostsHelper
  # Returns 5 posts per page
  def load_posts(page)
    Post.all.paginate(page: page, per_page: 5)
  end
end
