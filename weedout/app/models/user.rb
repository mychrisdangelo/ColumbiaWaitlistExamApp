class ProfessorValidator < ActiveModel::Validator

  def isRealProfessor(record)
    # Louis insert code here


    return true
  end

  def validate(record)
    if record.signup_as_professor == true && !isRealProfessor(record)
      record.errors[:base] << "Not a real professor."      
    end
  end
end


class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  before_validation :set_email
  after_validation :set_isprofessor
  validates_with ProfessorValidator

  def set_email
    if self.email == ""
      self.email = "#{self.uni}@columbia.edu"
    end
  end

  def set_isprofessor
    self.isprofessor = self.signup_as_professor
  end
end

