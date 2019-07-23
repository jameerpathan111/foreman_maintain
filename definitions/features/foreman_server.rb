module ForemanMaintain
  module Features
    class ForemanServer < ForemanMaintain::Feature
      metadata do
        label :foreman_server
        confine do
          server?
        end
      end

      def services
        [
          system_service('httpd', 30)
        ]
      end

      def plugins
        list_cmd = "export RUBYOPT='-W0'; foreman-rake plugin:list| grep 'Foreman plugin: '"
        plugin_list = execute(list_cmd).lines
        plugin_list.map do |line|
          plugin = line.split
          "#{plugin[2].chop}-#{plugin[3].chop}"
        end
      end

      def admin_username
        ForemanMaintain.config.admin_username ||
          (feature(:installer) && feature(:installer).initial_admin_username) ||
          'admin'
      end

      def config_files
        [
          '/etc/httpd',
          '/var/www/html/pub',
          '/etc/squid',
          '/etc/foreman',
          '/etc/selinux/targeted/contexts/files/file_contexts.subs',
          '/etc/sysconfig/foreman',
          '/usr/share/ruby/vendor_ruby/puppet/reports/foreman.rb',
          '/var/lib/foreman'
        ]
      end
    end
  end
end
