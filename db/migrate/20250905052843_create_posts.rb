class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :summary
      t.text :content
      t.string :read_time
      t.string :video_url
      t.date :published_date
      t.string :status, default: 'draft'

      t.timestamps
    end

    add_index :posts, :slug, unique: true
    add_index :posts, :status
    add_index :posts, :published_date
  end
end
