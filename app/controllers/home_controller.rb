class HomeController < ApplicationController
  def index
    render json: { welcome: I18n.t('hello') }, status: :ok
  end
end
