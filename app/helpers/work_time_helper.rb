module WorkTimeHelper
	def users_for_filtering(user_id)
		us = User.where(:type => "User")
		options_for_select([ ["all", ''] ] + us.map { |e| [ e.login, e.id ] }, user_id)

	end
end
