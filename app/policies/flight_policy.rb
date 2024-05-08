class FlightPolicy
  attr_reader :flight, :user

  def initialize(user, flight)
    @user = user
    @flight = flight
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @scope.all
    end
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def show?
    true
  end
end
