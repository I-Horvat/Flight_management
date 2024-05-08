# frozen_string_literal: true

class SessionPolicy
  attr_reader :user, :session

  def initialize(user, session)
    @user = user
    @session = session
  end

  def create?
    user.present?
  end

  def destroy?
    user.present?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
