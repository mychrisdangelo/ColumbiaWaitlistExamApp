class Course < ActiveRecord::Base
  	belongs_to :professor, class_name: "User"

	def self.search(search)
		  if search 
		  	begin 
		  	   Float(search)
			   where("call_number = '#{search}'")
			rescue
				Course.all
			end
		  else
		    Course.all
		  end
	end

end
