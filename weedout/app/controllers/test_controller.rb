class TestController < ApplicationController
  def new
    @course = Course.find(params[:course_id])
    if !@course then redirect_to professor_courses_path end
  end

  def create
    
    (1..params[:i].to_i).each do |i|
      a = Question.create text: params["questiontext-#{i}"], :course_id => params[:course_id]
      
      (1..4).each do |j|
        b = QuestionChoice.create text: params["questionresponse-#{i}-#{j}"], question: a
        if params["questionresponse-#{i}"] == j then
          a.correct_choice = b
          a.save
        end
      end
    end

    redirect_to professor_courses_path, notice: "Your test has been created"
  end
end
