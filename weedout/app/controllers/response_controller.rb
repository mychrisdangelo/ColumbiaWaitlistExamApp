class ResponseController < ApplicationController
  def show
	@course = Course.find(params[:course])

	@questions = Question.where("course_id = #{@course.id}")

	@question_choices = Array.new(10)

	(0..9).each do |i|
		@question_choices[i] = QuestionChoice.where("question_id = #{@questions[i].id}")
	end
  end

  def create
  	if Response.where(uni: current_user.uni, question_id: params["question-#{0}"]).take
  		redirect_to courses_path, notice: "Sorry, you have already taken this test"
  	else
	  	(0..9).each do |i|

	      r = Response.create uni: current_user.uni, :question_id => params["question-#{i}"], :question_choice_id => params["questionresponse-#{i}"]
	  	  r.save
	  	end
  		redirect_to courses_path, notice: "Your responses have been saved"
  	end
  end
end
