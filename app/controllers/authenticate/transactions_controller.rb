module Authenticate
  class TransactionsController < AuthenticationController
    before_action :check_user_id, only: :index

    def index
      @transactions = @current_user.transactions.order(creation_date: :desc).page(params[:page])
      total_pages = @transactions.total_pages
      serialized = ActiveModel::Serializer::CollectionSerializer.new(@transactions,
                                                                     serializer: ::Authenticate::TransactionSerializer)

      render json: { transactions: serialized, total_pages: total_pages }, status: :ok
    end

    def create
      result = Transactions::Create.new(parameters: transaction_params.merge(uuid: SecureRandom.uuid,
                                                                             user_id: @current_user.id)).call

      return render json: { errors: result.errors }, status: :unprocessable_entity unless result.valid?

      render status: :created
    end

    private

    def transaction_params
      params.require(:transaction).permit(:operator, :amount, :description, :creation_date)
    end

    def check_user_id
      message = I18n.t('errors.unauthenticated')
      render json: { error: message }, status: :unauthorized if params[:user_id] != @current_user.uuid
    end
  end
end
