class AccountsController < ApplicationController
  before_action :authenticate_account

  def show
    render json: { balance: current_account.balance }, status: :ok
  end

  def deposit
    amount = params[:amount].to_f
    current_account.deposit!(amount)
    render json: { balance: current_account.balance, message: "Deposit successful" }, status: :ok
  rescue ArgumentError, StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def withdraw
    amount = params[:amount].to_f
    current_account.withdraw!(amount)
    render json: { balance: current_account.balance, message: "Withdrawal successful" }, status: :ok
  rescue ArgumentError, StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
