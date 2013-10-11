class Professor::CoursesController < ApplicationController
	before_filter :authenticate_user!
	# http://stackoverflow.com/questions/7411577/devise-before-filter-authenticate-admin
	before_filter do
		redirect_to new_user_session_path unless current_user && current_user.isprofessor
	end

	def index
	  @courses = Course.all
	  @user = current_user
	end

end
