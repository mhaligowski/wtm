# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'wtm', :to => 'work_time#index'
post 'wtm', :to => 'work_time#index'

get 'wtm/report_present', :to => 'work_time#report_present'
post 'wtm/report_present', :to => 'work_time#report_present'

get 'wtm/report_task_time', :to => 'work_time#report_task_time'
post 'wtm/report_task_time', :to => 'work_time#report_task_time'

get 'wtm/toggle', :to => 'work_time#toggle'

get 'english/toggle', :to => 'english_time#toggle'

resources :work_time, :only => [:index, :show, :edit, :update] 