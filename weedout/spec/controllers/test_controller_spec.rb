require 'spec_helper'

def fill_params 
  params = {}
  params[:i] = "10"
  (1..10).each do |i|
    params["questiontext-#{i}"] = ""
    params["questionresponse-#{i}"] = ""
    (1..4).each do |j|
      params["questionresponse-#{i}-#{j}"] = ""
    end
  end
  params
end

describe TestController do
  let (:user) { FactoryGirl.build(:professor) } 
  let (:course) { FactoryGirl.create(:course, :professor => user) }
  let (:params) { fill_params }

  before :each do
    user.confirm!
    sign_in user
  end

  context "when the user submits an empty form" do
    it "should create no questions nor responses" do
      params[:course_id] = course.id
      post :create, params
      Question.all.should be_empty
      QuestionChoice.all.should be_empty
    end
  end

  context "when the user submits a question with choices but no text" do
    it "should not create a question for the choices" do
      params[:course_id] = course.id
      params["questionresponse-1-1"] = "Choice 1"
      params["questionresponse-1-2"] = "Choice 2"
      params["questionresponse-1-3"] = "Choice 3"
      params["questionresponse-1"] = "1"
      post :create, params
      Question.all.should be_empty
      QuestionChoice.all.should be_empty
    end
  end

  context "when the user submits a question with text but no choices" do
    it "should not create a question" do
      params[:course_id] = course.id
      params["questiontext-1"] = "Here's some question text!"
      post :create, params
      Question.all.should be_empty
      QuestionChoice.all.should be_empty
    end
  end

  context "when the professor enters question text with ASCII characters" do
    it "should create a question with the proper text" do
      question_text = "Here's some question text!"
      params[:course_id] = course.id
      params["questiontext-1"] = question_text
      params["questionresponse-1-1"] = "Choice 1"
      params["questionresponse-1-2"] = "Choice 2"
      params["questionresponse-1-3"] = "Choice 3"
      params["questionresponse-1"] = "1"
      post :create, params
      expect(Question.all.first.text).to eq(question_text)
      expect(QuestionChoice.all.count).to eq(3)
    end
  end

  context "when the professor enters question text with Unicode characters" do
    it "should create a question with the proper text" do
      question_text = "I \u2764 unicode characters!".encode("utf-8")
      params[:course_id] = course.id
      params["questiontext-1"] = question_text
      params["questionresponse-1-1"] = "Choice 1"
      params["questionresponse-1-2"] = "Choice 2"
      params["questionresponse-1-3"] = "Choice 3"
      params["questionresponse-1"] = "1"
      post :create, params
      expect(Question.all.first.text).to eq(question_text)
      expect(QuestionChoice.all.count).to eq(3)
    end
  end
  
  context "when the professor doesn't select a correct response" do
    it "should not create a question" do
      question_text = "Here's some question text"
      params[:course_id] = course.id
      params["questiontext-1"] = question_text
      params["questionresponse-1-1"] = "Choice 1"
      params["questionresponse-1-2"] = "Choice 2"
      params["questionresponse-1-3"] = "Choice 3"
      post :create, params
      expect(Question.all.count).to be(0)
      expect(QuestionChoice.all.count).to be(0)
    end
  end

  context "when the professor only enters information for the last question" do
    it "should create that question properly" do
      question_text = "Here's some question text!"
      params[:course_id] = course.id
      params["questiontext-10"] = question_text
      params["questionresponse-10-1"] = "Choice 1"
      params["questionresponse-10-2"] = "Choice 2"
      params["questionresponse-10-3"] = "Choice 3"
      params["questionresponse-10"] = "1"
      post :create, params
      expect(Question.all.count).to eq(1)
      expect(Question.all.first.text).to eq(question_text)
      expect(QuestionChoice.all.count).to eq(3)
    end
  end

  context "when the professor only enters question information for 1st question" do
    it "should create that question properly" do
      question_text = "Here's some question text!"
      params[:course_id] = course.id
      params["questiontext-1"] = question_text
      params["questionresponse-1-1"] = "Choice 1"
      params["questionresponse-1-2"] = "Choice 2"
      params["questionresponse-1-3"] = "Choice 3"
      params["questionresponse-1-4"] = "Choice 4"
      params["questionresponse-1"] = "1"
      post :create, params
      expect(Question.all.count).to eq(1)
      expect(Question.all.first.text).to eq(question_text)
      expect(QuestionChoice.all.count).to eq(4)
    end
  end
end
