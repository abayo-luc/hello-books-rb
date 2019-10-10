module WebToken
  SECRET = ENV['JWT_SECRET']
  class << self
    def decode(token)
      JWT.decode(token, SECRET, true, algorithm: 'HS256')[0]
    # raise custom error to be handled by custom handler
    rescue JWT::ExpiredSignature
      raise ExceptionHandler::ExpiredSignature, 'Token has expired'
    rescue JWT::DecodeError, JWT::VerificationError
      raise ExceptionHandler::DecodeError, 'Invalid token'
    end

    def encode(user)
      JWT.encode(token_params(user), WebToken::SECRET, 'HS256')
    end

    private
      def token_params(user)
        expDate = (Time.now + 2.weeks).to_i
        { id: user[:id], email: user[:email], exp: expDate }
      end
  end
end
