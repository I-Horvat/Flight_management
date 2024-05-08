class BookingPolicy
  attr_reader :user, :booking

  def initialize(user, booking)
    @user = user
    @booking = booking
  end

  def create?
    true
  end

  def index?
    if user.admin?
      true
    else
      user.bookings.exists?
    end
  end

  def show?
    user.admin? || booking.user_id == user.id
  end

  def update?
    user.admin? || booking.user_id == user.id
  end

  def destroy?
    user.admin? || booking.user_id == user.id
  end

  def permitted_attributes
    if user.admin?
      [:no_of_seats, :seat_price, :flight_id, :user_id]
    else
      [:no_of_seats, :seat_price, :flight_id]
    end
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
