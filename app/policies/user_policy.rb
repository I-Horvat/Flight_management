class UserPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    true
  end

  def index?
    user.admin?
  end

  def show?
    user.admin? || record.id == user.id
  end

  def update?
    user.admin? || record.id == user.id
  end

  def destroy?
    user.admin? || record.id == user.id
  end

  def update_role?
    user.admin?
  end

  def permitted_attributes
    if user&.admin?
      [:first_name, :last_name, :email, :password, :role]
    else
      [:first_name, :last_name, :email, :password]
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
        scope.where(id: user.id)
      end
    end
  end
end
