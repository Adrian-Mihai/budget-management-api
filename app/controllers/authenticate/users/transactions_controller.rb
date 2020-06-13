module Authenticate
  module Users
    class TransactionsController < AuthenticationController
      def index
        @transactions = @current_user.transactions.order(updated_at: :desc).page(params[:page])
        total_pages = @transactions.total_pages
        result = ActiveModel::Serializer::CollectionSerializer.new(@transactions,
                                                                   serializer: ::Authenticate::TransactionSerializer)

        render json: { transactions: result, total_pages: total_pages }, status: :ok
      end

      def show
        render json: transaction
      end

      def create
        result = Transactions::Create.new(parameters: transaction_params.merge(uuid: SecureRandom.uuid,
                                                                               user_id: @current_user.id)).call

        return render json: { errors: result.errors }, status: :unprocessable_entity unless result.valid?

        render json: {}, status: :created
      end

      def update
        transaction.update!(transaction_params)

        render json: {}, status: :ok
      end

      def destroy
        transaction.delete

        render json: {}, status: :ok
      end

      private

      def transaction
        @transaction ||= @current_user.transactions.find_by!(uuid: params[:id])
      end

      def transaction_params
        params.require(:transaction).permit(:operator, :amount, :description)
      end
    end
  end
end
