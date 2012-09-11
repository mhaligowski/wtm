class WorkTime < ActiveRecord::Base
	belongs_to :user

	#returns the current instance for the user or null, if not working right now
	def self.current(user)
		work_item = WorkTime.find_last_by_user_id(user)

		if work_item.nil? or not work_item.end.nil?
			nil
		else
			work_item
		end		
	end

end
