class WtmHookListener < Redmine::Hook::ViewListener
	# render the button
	render_on :view_welcome_index_top, :partial => "work_time/button"

	def view_users_form(context={})
		context[:controller].send(:render_to_string, {
			:partial => "work_time/permissions",
			:locals => context
			})
	end
end