module Authenticate
  class TransactionsController < AuthenticationController
    def create
      result = Transactions::Create.new(user_id: @current_user.id,
                                        parameters: transaction_params.merge(uuid: SecureRandom.uuid)).call

      return render json: { errors: result.errors }, status: :unprocessable_entity unless result.valid?

      render status: :created
    end

    private

    def transaction_params
      params.require(:transaction).permit(:operator, :amount, :description)
    end
  end
end
