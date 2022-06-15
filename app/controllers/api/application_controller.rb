module Api 
  class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: e }, status: :not_found
    end
  end
end
