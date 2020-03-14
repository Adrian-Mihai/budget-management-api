module Authenticate
  module Users
    class TransactionsController < AuthenticationController
      def create
        result = Transactions::Create.new(parameters: transaction_params.merge(budget_id: @current_user&.budget&.id,
                                                                               uuid: SecureRandom.uuid)).call

        return render json: { errors: result.errors }, status: :unprocessable_entity unless result.valid?

        render status: :created
      end

      private

      def transaction_params
        params.require(:transaction).permit(:operator, :amount, :description, :pay_day)
      end
    end
  end
end
