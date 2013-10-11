class CoursesController < ApplicationController
	before_filter :authenticate_user!
	# http://stackoverflow.com/questions/7411577/devise-before-filter-authenticate-admin
	before_filter do
		redirect_to new_user_session_path unless current_user && !current_user.isprofessor
	end

	def edit
  		@course = Course.find(params[:id])
  		# http://stackoverflow.com/questions/5799043/rails-association-how-to-add-the-has-many-object-to-the-owner
  		@course.students.build(params[:current_user])
  		@course.save
	end

	def index
	  @courses = Course.search(params[:search])
	  @user = current_user
	end

end
