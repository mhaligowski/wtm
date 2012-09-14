require_dependency '../lib/redmine/menu_manager'

# redmine only differs between project_menu and application_menu! but we want to display the
# time_tracker submenu only if the plugin specific controllers are called
module MenuPatch

  def self.included(base)
    base.send(:extend, ClassMethods)
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :render_main_menu, :wtm
      alias_method_chain :display_main_menu?, :wtm
    end
  end

  module ClassMethods

    def get_menu_name(project, params={})
      if (project && !project.new_record?)
        :project_menu
      else
        if %w(work_time).include? params[:controller]
          :wtm_menu
        else
          :application_menu
        end
      end
    end

  end

  module InstanceMethods

    def display_main_menu_with_wtm?(project)
      menu_name = Redmine::MenuManager::MenuHelper.get_menu_name(project, params)

      if menu_name == :wtm_menu && !User.current.admin?
        false
      else
        Redmine::MenuManager.items(menu_name).children.present?
      end
    end

    def render_main_menu_with_wtm(project)
      render_menu(Redmine::MenuManager::MenuHelper.get_menu_name(project, params), project)
    end

  end
end

Redmine::MenuManager::MenuHelper.send(:include, MenuPatch)