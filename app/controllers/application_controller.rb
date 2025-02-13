class ApplicationController < ActionController::API
  before_action :authenticate_account

  def current_account
    return unless decoded_token

    @current_account ||= Account.find_by(id: decoded_token[:account_id])
  end

  private

  def authenticate_account
    if decoded_token.nil?
      render json: { error: "Unauthorized or token expired" }, status: :unauthorized
    end
  end

  def decoded_token
    auth_header = request.headers["Authorization"]
    return unless auth_header

    token = auth_header.split(" ").last
    JsonWebToken.decode(token)
  end
end
