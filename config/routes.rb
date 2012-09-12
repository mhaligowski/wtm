# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'wtm', :to => 'work_time#index'
post 'wtm', :to => 'work_time#index'

get 'wtm/report_present', :to => 'work_time#report_present'
post 'wtm/report_present', :to => 'work_time#report_present'

get 'wtm/toggle', :to => 'work_time#toggle'