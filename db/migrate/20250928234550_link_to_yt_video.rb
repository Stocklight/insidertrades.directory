class LinkToYtVideo < ActiveRecord::Migration[8.0]
  def change
    Post.destroy_all
    rename_column :posts, :video_url, :youtube_slug
  end
end
