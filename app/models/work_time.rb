class WorkTime < ActiveRecord::Base
	belongs_to :user

	scope :find_all_by_month_and_year, lambda { |month, year| where(:start => DateTime.new(year, month, 1)..DateTime.new(year, month+1, 1)) }

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
