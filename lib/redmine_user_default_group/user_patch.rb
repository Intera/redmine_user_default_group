module RedmineUserDefaultGroup

  # Patches Redmine's Users dynamically.  Adds a +after_create+ filter.
  module UserPatch

    def self.included(base) # :nodoc:

      base.send(:include, InstanceMethods)

      # Same as typing in the class 
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        after_create :add_default_group_to_user
      end

    end

    module InstanceMethods
      def add_default_group_to_user
        groups = Group.where('LOWER(lastname) = ?', Setting.plugin_redmine_user_default_group['group'].downcase)
        groups.first.users << self unless groups.empty?
      end
    end

  end
end

User.send(:include, RedmineUserDefaultGroup::UserPatch)