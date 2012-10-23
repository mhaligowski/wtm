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
			if @user.wtm_permission.nil? then @user.create_wtm_permission end

			@user.can_see_wtm_button = params[:user][:can_see_wtm_button] if params[:user][:can_see_wtm_button]
			@user.can_work_remotely = params[:user][:can_work_remotely] if params[:user][:can_work_remotely]
			@user.can_see_english_button = params[:user][:can_see_english_button] if params[:user][:can_see_english_button]

			@user.wtm_permission.save!

			self.update_without_wtm

		end
	end
end

UsersController.send(:include, UsersControllerPatch)