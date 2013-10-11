class Course < ActiveRecord::Base
  	belongs_to :user

	def self.search(search)
	  if search
	    where("call_number = '#{search}'")
	  else
	    Course.all
	  end
	end

end
