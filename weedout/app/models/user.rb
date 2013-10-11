class ProfessorValidator < ActiveModel::Validator
  def validate(record)
    if record.signup_as_professor == true
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
  validates_with ProfessorValidator

  def set_email
    if self.email == ""
      self.email = "#{self.uni}@columbia.edu"
    end
  end

  def testme
    logger.info "testme was called"
  end
end

