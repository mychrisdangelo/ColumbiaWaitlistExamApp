class Professor::CoursesController < ApplicationController
	before_filter :authenticate_user!

	def index
	  @courses = Course.all
	  @user = current_user
	end

end
