require 'WtmHookListener'

Redmine::Plugin.register :wtm do
  name 'Wtm plugin'
  author 'Mateusz Haligowski'
  description 'Redmine plugin registering work time'
  version '0.1-dev'
  author_url 'http://github.com/mhaligowski/'
  permission :work_items, { :work_items => [:index, :toggle] }, :public => false
  menu :top_menu, :work_items, { :controller => 'work_time', :action => 'index' }, :caption => :work_time_menu_item
end
