class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
  	if user_signed_in? && current_user.isprofessor == true
  		redirect_to professor_courses_path
  	else
  		redirect_to courses_path
  	end 
  end
end
