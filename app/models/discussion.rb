class Discussion < ApplicationRecord
  belongs_to :user
  belongs_to :category, touch: true, optional: true
  has_many :posts, dependent: :destroy

  accepts_nested_attributes_for :posts

  validates :name, presence: true

  scope :with_posts_count, ->{ select("*, (#{Post.where('discussion_id = posts.discussion_id').select('COUNT(*)').to_sql}) AS posts_count") }

  def posts_count
    has_attribute?(:posts_count) ? self[:posts_count] : posts.count
  end

  def to_param
    "#{id}-#{name.downcase}"[0..100].parameterize
  end
end
