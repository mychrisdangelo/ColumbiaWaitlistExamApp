class TestController < ApplicationController
  def new
    @course = Course.find(params[:course_id])
    if !@course then redirect_to professor_courses_path end
    if @course.questions.count > 0 then
      redirect_to professor_courses_path,
        notice: "Test has already been created for this course"
    end
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

  def show
    @grade_list = Hash.new
    @course = params[:course]
    # first check all responses for this course
    questions = Course.find(@course).questions
    @first_question = questions.first

    @responses_fq = @first_question.question_responses
    @responses_fq.each do |r|
      u = r.uni
      @grade_list[u] = Array.new(11)
      @grade_list[u][10] = 0
      i = 0
      responses_for_this_uni = Response.where(uni: u)
      responses_for_this_uni.each do |r_uni|
        if r_uni.question_choice_id == r_uni.question.correct_choice_id then
          @grade_list[u][i] = 1
          @grade_list[u][10] = @grade_list[u][10] + 1
        else
          @grade_list[u][i] = 0
        end
        i = i + 1
      end
    end



  end
end
