class Category < ApplicationRecord
  has_many :discussions, dependent: :nullify

  validates :name, presence: true

  scope :sorted, -> { order(:name) }
  scope :with_discussions_count, ->{ select("*, (#{Discussion.where('category_id = categories.id').select('COUNT(*)').to_sql}) AS discussions_count") }

  def discussions_count
    has_attribute?(:discussions_count) ? self[:discussions_count] : discussions.count
  end

  def to_param
    "#{id}-#{name.downcase}"[0..100].parameterize
  end

end
