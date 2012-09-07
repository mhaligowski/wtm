class WtmHookListener < Redmine::Hook::ViewListener
	# render the button
	render_on :view_welcome_index_top, :partial => "work_time/button"

	def view_layouts_base_html_head(context = {})
		# add the stylesheet
		return stylesheet_link_tag('wtm', :plugin => 'wtm')
	end
end