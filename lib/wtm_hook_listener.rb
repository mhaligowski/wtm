class WtmHookListener < Redmine::Hook::ViewListener
	# render the button
	render_on :view_welcome_index_top, :partial => "work_time/button"

	def view_my_account(context={})
	    return content_tag("p", "Custom content added to the right")
	end
end