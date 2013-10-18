class Professor::CoursesController < ApplicationController
  require 'open-uri'
  require 'json'

	before_filter :authenticate_user!
	# http://stackoverflow.com/questions/7411577/devise-before-filter-authenticate-admin
	before_filter do
		redirect_to new_user_session_path unless current_user && current_user.isprofessor
	end

	def index
	  @prof_name = "LEE"
	  m_prof_name = @prof_name.gsub ' ', '%20' 
	  url ='http://data.adicu.com/courses/v2/sections?api_token=b9ac8a50324311e390c312313d000d18&pretty=true&professor='+m_prof_name
	  json_object = JSON.parse(open(url).read())
    json_object["data"].each do |section|
      url = "http://data.adicu.com/courses/v2/courses?api_token=b9ac8a50324311e390c312313d000d18&pretty=true&course=#{section["Course"]}"
      course_info = JSON.parse(open(url).read())
      course_info["data"][0]["Sections"] = nil
      section.merge! course_info["data"][0]
    end
	  @course_list = json_object["data"]
	  @user = current_user
	end

  def create
    course = params[:course]
    courseHash = Hash.new
    course.keys.each do |key|
      newkey = key.underscore
      if Course.column_names.include?(newkey)
        courseHash[newkey] = course[key]
      end
    end
    newcourse = Course.create courseHash
    redirect_to new_test_path(newcourse.id)
  end
end
