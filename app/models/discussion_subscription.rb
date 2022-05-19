class DiscussionSubscription < ApplicationRecord
  belongs_to :discussion
  belongs_to :user

  scope :opt_in, -> { where(subscription_type: "opt_in") }
  scope :opt_out, -> { where(subscription_type: "opt_out") }

  validates :subscription_type, inclusion: { in: %w[opt_in opt_out] }
  validates :user_id, uniqueness: { scope: :discussion_id }

  def toggle!
    update!(subscription_type: subscription_type == "opt_in" ? "opt_out" : "opt_in")
  end

  def opt_in?
    subscription_type == "opt_in"
  end

  def opt_out?
    subscription_type == "opt_out"
  end
end
