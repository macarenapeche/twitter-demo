class GraphqlController < ActionController::API  
  before_action :authorize_request

  def index
    render json: Schema.execute(params[:query], variables: params[:variables], context: {current_user: @current_user})
  end

  private

  def authorize_request
    begin
      @decoded = Api::JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def header
    @header ||= begin
      header = request.headers['Authorization']
      header.split(' ').last if header
    end
  end
end
