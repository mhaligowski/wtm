# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'wtm', :to => 'work_time#index'
get 'wtm/toggle', :to => 'work_time#toggle'