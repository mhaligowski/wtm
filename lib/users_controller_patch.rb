require_dependency 'users_controller'

module UsersControllerPatch
	def self.included(base)
		base.send(:extend, ClassMethods)
		base.send(:include, InstanceMethods)

		base.class_eval do
			alias_method_chain :update, :wtm
		end
	end

	module ClassMethods 
	end

	module InstanceMethods
		def update_with_wtm
			@user.show_wtm_button = params[:user][:show_wtm_button] if params[:user][:show_wtm_button]
			@user.remote_wtm_toggle = params[:user][:remote_wtm_toggle] if params[:user][:remote_wtm_toggle]

			@user.wtm_permission.save!

			self.update_without_wtm

		end
	end
end

UsersController.send(:include, UsersControllerPatch)