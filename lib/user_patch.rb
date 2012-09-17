require_dependency 'project'
require_dependency 'principal'
require_dependency 'user'

module UserPatch
	def self.included(base)
		base.extend(ClassMethods)

		base.send(:include, InstanceMethods)

		base.class_eval do 
			unloadable

			after_create :create_wtm_permission
			after_destroy :destroy_wtm_permission	
		end
	end

	module ClassMethods
	end

	module InstanceMethods
		def create_wtm_permission
			puts "dupa"
			self.reload
			WtmPermission.create :user_id => self.id

			true
		end

		def destroy_wtm_permission
			WtmPermission.destroy_all :user_id => self.id
		end

		def show_wtm_button?
			true
		end

		def remote_wtm_toggle?
			true
		end

		def show_wtm_button; false end
		def remote_wtm_toggle; false end

	end
end

User.send(:include, UserPatch)