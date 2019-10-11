module RequestHelpers
  include WebToken
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end

  def auth_user(user)
    JWT.encode({ id: user.id, email: user.email }, WebToken::SECRET, 'HS256')
  end
end
