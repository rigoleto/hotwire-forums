class Post < ApplicationRecord
  belongs_to :user
  belongs_to :discussion

  has_rich_text :body

  validates :body, presence: true

end
