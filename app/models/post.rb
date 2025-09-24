class Post < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w[draft published archived] }
  
  scope :published, -> { where(status: 'published') }
  scope :by_date, -> { order(published_date: :asc, created_at: :desc) }
  
  before_validation :generate_slug, if: -> { slug.blank? && title.present? }
  
  def to_param
    slug
  end
  
  def published?
    status == 'published'
  end
  
  private
  
  def generate_slug
    self.slug = title.parameterize if title.present?
  end
end
