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

			has_one :wtm_permission
		end
	end

	module ClassMethods
	end

	module InstanceMethods
		def create_wtm_permission
			self.reload
			WtmPermission.create :user_id => self.id

			true
		end

		def destroy_wtm_permission
			WtmPermission.destroy_all :user_id => self.id
		end

		def can_see_wtm_button
			if self.wtm_permission.nil?
				false
			else
				self.wtm_permission.can_see_wtm_button
			end
		end

		def can_see_wtm_button=(val)
			self.wtm_permission.can_see_wtm_button = val
		end

		def can_see_wtm_button?
			self.can_see_wtm_button
		end

		def can_work_remotely
			if self.wtm_permission.nil?
				false
			else
				self.wtm_permission.can_work_remotely
			end
		end

		def can_work_remotely=(val)
			self.wtm_permission.can_work_remotely = val
		end


		def can_work_remotely?
			self.can_work_remotely
		end

		def can_see_english_button
			if self.wtm_permission.nil?
				false
			else
				self.wtm_permission.can_see_english_button
			end
		end

		def can_see_english_button=(val)
			self.wtm_permission.can_see_english_button = val
		end

		def can_see_english_button?
			self.can_see_english_button
		end
	end
end

User.send(:include, UserPatch)