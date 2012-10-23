class EnglishTime < ActiveRecord::Base
	belongs_to :user
  unloadable

  def self.current(user)
  	english_time = EnglishTime.find_last_by_user_id(user)

  	if english_time.nil? or not english_time.end.nil?
  		nil
  	else
  		english_time
  	end
  end
end
