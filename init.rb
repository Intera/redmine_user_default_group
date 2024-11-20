module RedmineUserDefaultGroup
  module UserPatch
    def self.prepended(base)
      base.class_eval do
        after_create :add_default_group_to_user
      end
    end

    def add_default_group_to_user
      group_name = Setting.plugin_redmine_user_default_group["group"]
      return unless group_name.present?

      groups = Group.where("LOWER(lastname) = ?", group_name.downcase)
      groups.first.users << self unless groups.empty?
    end
  end
end

class AfterPluginsLoadedHook < Redmine::Hook::Listener
  def after_plugins_loaded(_context = {})
    User.prepend RedmineUserDefaultGroup::UserPatch
  end
end

Redmine::Plugin.register :redmine_user_default_group do
  name "Redmine Default Group Plugin"
  author "Intera GmbH"
  description "This plugin assigns a default group to newly created users."
  version "0.2.0"
  url "https://github.com/Intera/redmine_user_default_group"
  requires_redmine :version_or_higher => "6.0.0"
  settings partial: "settings/default_group", default: {"group" => false}
end
