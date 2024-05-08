# frozen_string_literal: true

class Session
  attr_accessor :user, :token

  def initialize(user, token)
    @user = user
    @token = token
  end

  def as_json(_options = {})
    { session: { user: @user.as_json, token: @token } }
  end
end
