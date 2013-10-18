class TestController < ApplicationController
  def new
    @course = Course.find(params[:course_id])
    if !@course then redirect_to professor_courses_path end
  end
end
