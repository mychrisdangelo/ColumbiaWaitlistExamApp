class ResponseController < ApplicationController
  def show
	@course = params[:course]
  end
end
