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
    video_url: "https://www.youtube.com/embed/4jmB_efkiRs?si=pOkU4qezTikJh66x",
    published_date: Date.new(2025, 9, 5),
    status: "published",
    content: "This is the main post content that will be populated later..."
  },
  {
    title: "Turbolinks / View Component, no webpacker node or js",
    slug: "turbolinks-view-component-no-webpacker",
    summary: "Building modern Rails apps without JavaScript complexity using Turbolinks and ViewComponent",
    read_time: "5 min read",
    video_url: nil,
    published_date: Date.new(2025, 9, 6),
    status: "draft",
    content: ""
  },
  {
    title: "Kamal to AWS with Terraform",
    slug: "kamal-aws-terraform",
    summary: "Deploying Rails applications to AWS using Kamal and Infrastructure as Code with Terraform",
    read_time: "8 min read",
    video_url: nil,
    published_date: Date.new(2025, 9, 7),
    status: "draft",
    content: ""
  },
  {
    title: "Ahoy & Blazer analytics integration",
    slug: "ahoy-blazer-analytics",
    summary: "Adding user analytics and business intelligence to Rails apps with Ahoy and Blazer",
    read_time: "6 min read",
    video_url: nil,
    published_date: Date.new(2025, 9, 8),
    status: "draft",
    content: ""
  },
  {
    title: "Rails auth signin with socials (no Omniauth/Devise)",
    slug: "rails-auth-socials-no-omniauth",
    summary: "Implementing social authentication in Rails without heavy dependencies like Omniauth or Devise",
    read_time: "7 min read",
    video_url: nil,
    published_date: Date.new(2025, 9, 9),
    status: "draft",
    content: ""
  },
  {
    title: "Plug in reads from Stocklight DB and show data",
    slug: "stocklight-db-integration",
    summary: "Connecting to external financial databases and displaying insider trading data in Rails",
    read_time: "10 min read",
    video_url: nil,
    published_date: Date.new(2025, 9, 10),
    status: "draft",
    content: ""
  },
  {
    title: "Claude Code UI design",
    slug: "claude-code-ui-design",
    summary: "Using AI to design and implement user interfaces with Claude Code assistance",
    read_time: "4 min read",
    video_url: nil,
    published_date: Date.new(2025, 9, 11),
    status: "draft",
    content: ""
  }
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
