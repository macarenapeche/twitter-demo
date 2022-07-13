module Api 
  class ApplicationController < ActionController::API
    def not_found
      render json: { error: 'not_found' }
    end
  
    def authorize_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      begin
        @decoded = JsonWebToken.decode(header)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        nil
      end
    end


    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: e }, status: :not_found
    end
  end
end
