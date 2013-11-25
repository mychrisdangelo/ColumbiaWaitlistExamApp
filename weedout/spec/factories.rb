require 'factory_girl'

FactoryGirl.define do
  factory :student, class: User do
    firstname   "Louis"
    lastname    "Croce"
    uni         "ljc2655"
    email       "ljc2655@columbia.edu"
    password    "fakepassword"
    isprofessor false
    full_name   nil
    signup_as_professor false
  end

  factory :professor, class: User do
    firstname   "Stephen"
    lastname    "Edwards"
    uni         "jrb2194"
    email       "jrb2194@columbia.edu"
    password    "fakepassword"
    isprofessor true
    full_name   nil
    signup_as_professor true
  end

  factory :professor_jonathan, class: User do
    firstname   "Jonathan"
    lastname    "Edwards"
    uni         "jrb2194"
    email       "jrb2194@columbia.edu"
    password    "fakepassword"
    isprofessor true
    full_name   nil
    signup_as_professor true
  end

  factory :course do
    department_code "TEST"
    call_number     12345
    term            "20131"
    section_full    "TEST1101W013"
    course_title    "TESTING COURSE"
    description     "This is a very short description for the testing course"
    num_fixed_units "2"
    room            "1111"
    building_1      "ASE"
  end
end
