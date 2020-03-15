module Authenticate
  module Users
    class BudgetsController < AuthenticationController
      def create
        result = Budgets::Create.new(parameters: budget_params.merge(user_id: @current_user.id,
                                                                     uuid: SecureRandom.uuid)).call

        return render json: { errors: result.errors }, status: :unprocessable_entity unless result.valid?

        render status: :created
      end

      private

      def budget_params
        params.require(:budget).permit(:amount, transactions_attributes: %i[operator amount description])
      end
    end
  end
end
