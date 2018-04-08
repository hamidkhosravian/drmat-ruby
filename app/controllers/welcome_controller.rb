class WelcomeController < ApplicationController
  def index
    render json: {response: "Welcome to DrMat.", status: 200}, status: 200
  end
end
