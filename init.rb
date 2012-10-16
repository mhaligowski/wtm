require 'wtm_hook_listener'
require 'menu_patch'
require 'user_patch'
require 'users_controller_patch'

Redmine::Plugin.register :wtm do
  name 'Wtm plugin'
  author 'Mateusz Haligowski'
  description 'Redmine plugin registering work time'
  version '0.1-dev'
  author_url 'http://github.com/mhaligowski/'

  settings :default => {
    'local_ip_pattern' => '127.0.0.1'
  }, :partial => "settings/wtm_settings"
  
  menu(:wtm_menu,
  	:work_items_menu_item,
  	{ :controller => 'work_time', :action => 'index'},
  	:caption => :report_time)

  menu(:wtm_menu, 
  	:work_items_report_present_menu_item, 
  	{ :controller => 'work_time', :action => 'report_present'}, 
  	:caption => :report_present)

  menu(:wtm_menu,
  	:work_items_report_time_task_menu_item,
  	{ :controller => 'work_time', :action => 'report_task_time'},
  	:caption => :report_time_task)

  #raporty
  menu(:top_menu, 
  	:work_items, 
  	{ :controller => 'work_time', :action => 'index' },
   	:caption => :work_time_menu_item,
 	  :if => Proc.new{ User.current.logged? })
end
