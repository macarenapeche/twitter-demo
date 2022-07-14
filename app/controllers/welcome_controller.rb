class WelcomeController < ApplicationController
  http_basic_authenticate_with name: "user", password: "password", except: :index

  def index
  end

  def about
  end
end
