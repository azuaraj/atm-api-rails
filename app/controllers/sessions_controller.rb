class SessionsController < ApplicationController
  before_action :authenticate_account, only: [:destroy]

  def create
    account = Account.find_by(atm_account_number: params[:atm_account_number])

    if account&.authenticate(params[:pin])
      token = JsonWebToken.encode(account_id: account.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid account number or PIN" }, status: :unauthorized
    end
  end

  def destroy
    if decoded_token && decoded_token[:jti]
      RevokedToken.create(jti: decoded_token[:jti])
    end

    render json: { message: "Logged out successfully" }, status: :ok
  end
end
