# frozen_string_literal: true

# User permissions are defined in an Ability class.
class Ability
  include CanCan::Ability
  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud

    if user&.admin?
      can :manage, :all
      cannot :destroy, User, id: user.id
    elsif user&.active
      can :read, :all
      # User permissions
      can %i[edit update], User, id: user.id, active: true
      can %i[following followers], User
      cannot %i[index new create destroy], User
      # UserSession permissions
      can :destroy, UserSession
      # Relationship permissions
      can %i[create destroy], Relationship
      # Post permissions
      can :destroy, Post, user_id: user.id
    else
      can :read, :all
      # User permissions
      can %i[show new create], User
      # UserSession permissions
      can %i[new create], UserSession
      # Relationship permissions
      cannot :all, Relationship
    end
  end
end
