class Discussion < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  def to_param
    "#{id}-#{name.downcase}"[0..100].parameterize
  end
end
