class Discussion < ApplicationRecord
  belongs_to :user
  belongs_to :category, touch: true, optional: true
  has_many :posts, dependent: :destroy
  has_many :users, through: :posts
  has_many :discussion_subscriptions, dependent: :destroy
  has_many :subscribers, -> { merge(DiscussionSubscription.opt_in) }, through: :discussion_subscriptions, source: :user
  has_many :ignorers, -> { merge(DiscussionSubscription.opt_out) }, through: :discussion_subscriptions, source: :user

  accepts_nested_attributes_for :posts, reject_if: proc {|attrs| attrs[:body].blank? }

  validates :name, presence: true

  scope :ordered, -> { order(pinned: :desc).order(updated_at: :desc) }
  scope :with_posts_count, -> { select("*, (#{Post.where('discussion_id = posts.discussion_id').select('COUNT(*)').to_sql}) AS posts_count") }

  def posts_count
    has_attribute?(:posts_count) ? self[:posts_count] : posts.count
  end

  def to_param
    "#{id}-#{name.downcase}"[0..100].parameterize
  end

  def subscribed_users
    (users + subscribers) - ignorers
  end

  def subscription_for(user)
    return nil if user.nil?
    discussion_subscriptions.find_by(user: user)
  end

  def toggle_subscription!(user)
    if subscription = subscription_for(user)
      subscription.toggle!
    elsif posts.where(user: user).any?
      discussion_subscriptions.opt_out.where(user: user).create!
    end
  end
end
