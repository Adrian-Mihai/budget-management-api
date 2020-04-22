module Authenticate
  class GraphsController < AuthenticationController
    def show
      result = Graphs::Show.new(user: @current_user).call
      render json: result.informations, status: :ok
    end
  end
end