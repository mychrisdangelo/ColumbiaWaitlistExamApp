class Question < ActiveRecord::Base
  has_many :question_choices, class_name: "QuestionChoice"
  has_one :correct_choice, class_name: "QuestionChoice"
end
