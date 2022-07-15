module Api 
  class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: e }, status: :not_found
    end

    def authorize_request
      begin
        @decoded = JsonWebToken.decode(header)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    end

    # def current_user
    #   decoded = JsonWebToken.decode(header)
    #   @current_user = User.find(decoded[:user_id])
    # rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    # ensure
    #   return @current_user
    # end

    def header
      @header ||= begin
        header = request.headers['Authorization']
        header.split(' ').last if header
      end
    end
  end
end
