require 'redmine'
require 'redmine_user_default_group/user_patch'

Redmine::Plugin.register :redmine_user_default_group do
  name 'Redmine Default Group plugin'
  author 'Intera GmbH'
  description 'This plugin assigns a default group to newly created users.'
  version '0.0.1'
  url 'https://github.com/Intera/redmine_user_default_group'
  settings :partial => 'settings/default_group',
           :default => {
               :group => false,
           }

end
