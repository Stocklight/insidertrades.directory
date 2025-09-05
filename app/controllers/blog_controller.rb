class BlogController < ApplicationController
  def index
    @posts = Post.published.by_date
  end

  def show
    @post = Post.find_by!(slug: params[:slug])
    @related_posts = Post.where.not(id: @post.id).by_date.limit(6)
  rescue ActiveRecord::RecordNotFound
    redirect_to built_with_rails_path, alert: "Post not found"
  end
end
