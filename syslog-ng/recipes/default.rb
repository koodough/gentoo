include_recipe "gentoo::portage"

unless node[:gentoo][:use_flags].include?("syslog")
  node[:gentoo][:use_flags] << "syslog"
  generate_make_conf "added syslog USE flag"
end

package "app-admin/syslog-ng" do
  action :upgrade
end

service "syslog-ng" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  subscribes :restart, resources(:package => "app-admin/syslog-ng")
end

if node.run_list?("recipe[logrotate]")
  logrotate_config "syslog-ng"
end

if node.run_list?("recipe[monit]")
  monit_check "syslog-ng"
end

if node.run_list?("recipe[nagios::nrpe]")
  nrpe_command "syslog-ng"
end
