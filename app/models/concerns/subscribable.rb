module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, dependent: :destroy
    has_many :subscribers, through: :subscriptions, source: :user

    after_create { subscribe(user) }
  end

  def subscribe(user)
    subscriptions.create(user: user)
  end

  def unsubscribe(user)
    subscriptions.find_by(user: user).destroy
  end

  def subscribed?(user)
    subscriptions.find_by(user: user)
  end
end
