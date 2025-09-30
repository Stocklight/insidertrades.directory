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
    title: "Google Signin with Rails Authentication Generator",
    slug: "google-signin-with-rails-authentication-generator",
    summary: "Adding Google Signin to a Ruby on Rails app using the authentication generator",
    read_time: "5 min read + 13 min video",
    youtube_slug: "tCVEMj-D5zI",
    published_date: Date.new(2025, 9, 29),
    status: "published"
  },
  {
    title: "Exception Notifier with Slack integration",
    slug: "exception-notifier-with-slack-integration",
    summary: "Adding exception notifier to a Ruby on Rails app with a Slack integration - no data dog / airbrake / rollbar / sentry / etc.",
    read_time: "5 min read + 10 min video",
    youtube_slug: nil,
    published_date: Date.new(2025, 11, 1),
    status: "draft"
  },
  {
    title: "Ahoy & Blazer analytics integration",
    slug: "ahoy-blazer-analytics-claude-voice-cli",
    summary: "Adding user analytics and business intelligence to Rails apps with Ahoy and Blazer - implemented with Claude Code voice control",
    read_time: "8 min read",
    youtube_slug: "VT0iyi8y8Q4",
    published_date: Date.new(2025, 9, 30),
    status: "published"
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

# Blazer queries for analytics
puts "Creating Blazer queries..."

blazer_queries = [
  {
    name: "Referrals by Domain",
    description: "Track website visits grouped by referring domain",
    statement: <<~SQL
      SELECT#{' '}
        referring_domain,
        COUNT(*) as visits,
        COUNT(DISTINCT visitor_token) as unique_visitors,
        DATE(started_at) as visit_date
      FROM ahoy_visits#{' '}
      WHERE referring_domain IS NOT NULL#{' '}
        AND started_at >= date('now', '-30 days')
      GROUP BY referring_domain, DATE(started_at)
      ORDER BY visits DESC, visit_date DESC
      LIMIT 50
    SQL
  },
  {
    name: "Visits by Landing Page",
    description: "Track website visits grouped by landing page URL",
    statement: <<~SQL
      SELECT#{' '}
        landing_page,
        COUNT(*) as visits,
        COUNT(DISTINCT visitor_token) as unique_visitors,
        DATE(started_at) as visit_date
      FROM ahoy_visits#{' '}
      WHERE started_at >= date('now', '-30 days')
      GROUP BY landing_page, DATE(started_at)
      ORDER BY visits DESC, visit_date DESC
      LIMIT 50
    SQL
  },
  {
    name: "New Users by Day",
    description: "Track new user registrations grouped by day",
    statement: <<~SQL
      SELECT#{' '}
        DATE(created_at) as registration_date,
        COUNT(*) as new_users,
        COUNT(CASE WHEN google_user_id IS NOT NULL THEN 1 END) as google_signups,
        COUNT(CASE WHEN google_user_id IS NULL THEN 1 END) as email_signups
      FROM users#{' '}
      WHERE created_at >= date('now', '-30 days')
      GROUP BY DATE(created_at)
      ORDER BY registration_date DESC
    SQL
  }
]

blazer_queries.each do |query_attrs|
  query = Blazer::Query.find_or_initialize_by(name: query_attrs[:name])
  query.assign_attributes(query_attrs.merge(data_source: "main"))

  if query.save
    puts "✓ Created/Updated Blazer query: #{query.name}"
  else
    puts "✗ Error creating query #{query_attrs[:name]}: #{query.errors.full_messages.join(', ')}"
  end
end

puts "Seed data loaded successfully!"
