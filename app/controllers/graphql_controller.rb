class GraphqlController < ActionController::API  
  def index
    render json: Schema.execute(params[:query], variables: params[:variables])
  end
end
