class WtmHookListener < Redmine::Hook::ViewListener
	# render the button
	render_on :view_welcome_index_top, :partial => "work_time/button"

end