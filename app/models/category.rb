class Category < ApplicationRecord
  has_many :discussions, dependent: :nullify

  validates :name, presence: true

  scope :sorted, -> { order(:name) }
end
