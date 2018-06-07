class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :destroy, [Question, Answer], user_id: user.id
    can :update, [Question, Answer], user_id: user.id
    can [:read, :me], [User]

    alias_action :like, :dislike, to: :rate

    can :rate, [Question, Answer] do |resource|
      !user.author_of?(resource)
    end

    can :cancel, [Question, Answer] do |resource|
      resource.voted?(user)
    end

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :set_best, Answer do |answer|
      user.author_of?(answer.question) && !answer.best?
    end
  end
end
