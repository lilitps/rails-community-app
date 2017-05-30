module PostsHelper
  # Returns 5 posts per page
  def feed(page)
    Post.paginate(page: page, per_page: 5)
  end
end
