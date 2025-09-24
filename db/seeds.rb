# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Blog posts for the technical construction series
posts_data = [
  {
    title: "Claude Code --dangerously-skip-permissions",
    slug: "claude-code-dangerously-skip-permissions",
    summary: "A new Ruby on Rails project built agentically, plus Playwright",
    read_time: "3 min read + 5 min video",
    youtube_slug: "4jmB_efkiRs",
    published_date: Date.new(2025, 9, 5),
    status: "published"
  },
  {
    title: "Kamal to Digital Ocean with Open Tofu (Terraform)",
    slug: "kamal-digital-ocean-open-tofu-terraform",
    summary: "Deploying Rails a application to Digital Ocean using Kamal and Infrastructure as Code with Open Tofu (Terraform)",
    read_time: "10 min read + 19 min video",
    youtube_slug: "5NHOwOTCn_k",
    published_date: Date.new(2025, 9, 22),
    status: "published"
  },
  {
    title: "Turbolinks / View Component, no webpacker node or js",
    slug: "turbolinks-view-component-no-webpacker",
    summary: "Building modern Rails apps without JavaScript complexity using Turbolinks and ViewComponent",
    read_time: "5 min read",
    youtube_slug: nil,
    published_date: Date.new(2025, 11, 1),
    status: "draft"
  },
  {
    title: "Ahoy & Blazer analytics integration",
    slug: "ahoy-blazer-analytics",
    summary: "Adding user analytics and business intelligence to Rails apps with Ahoy and Blazer",
    read_time: "6 min read",
    youtube_slug: nil,
    published_date: Date.new(2025, 12, 1),
    status: "draft"
  },
]

puts "Creating blog posts..."

posts_data.each do |post_attrs|
  post = Post.find_or_initialize_by(slug: post_attrs[:slug])
  post.assign_attributes(post_attrs)
  
  if post.save
    puts "✓ Created/Updated: #{post.title}"
  else
    puts "✗ Error creating #{post_attrs[:title]}: #{post.errors.full_messages.join(', ')}"
  end
end

puts "Seed data loaded successfully!"
