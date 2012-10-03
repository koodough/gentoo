include_recipe "eix"

link "/etc/make.profile" do
  to "../../usr/portage/profiles/#{node['gentoo']['profile']}"
end

Chef::Log.debug("Generating /etc/portage/make.conf: #{params['name']}")

template "/etc/portage/make.conf" do
  source "make.conf.erb"
  cookbook "gentoo"
  owner "root"
  group "root"
  mode "0644"
  action :create
  variables(
    :use_flags => node['gentoo']['use_flags'],
    :chost => "#{node['kernel']['machine']}-pc-linux-gnu",
    :cflags => node['gentoo']['cflags'],
    :makeopts => [node['gentoo']['makeopts']].flatten,
    :features => [node['gentoo']['portage_features']].flatten,
    :emerge_options => [node['gentoo']['emerge_options']].flatten,
    :overlays => [node['gentoo']['overlay_directories']].flatten,
    :collision_ignores => [node['gentoo']['collision_ignores']].flatten,
    :licenses => [node['gentoo']['accept_licenses']].flatten,
    :ruby_targets => [node['gentoo']['ruby_targets']].flatten,
    :use_expands => node['gentoo']['use_expands'],
    :elog_mailuri => node['gentoo']['elog_mailuri'],
    :elog_mailfrom => node['gentoo']['elog_mailfrom'],
    :rsync_mirror => node['gentoo']['rsync_mirror'],
    :distfile_mirrors => [node['gentoo']['distfile_mirrors']].flatten,
    :portage_binhost => node['gentoo']['portage_binhost'],
    :extra_make_conf_variables => node['gentoo']['extra_make_conf_variables']
  )
end

directory "/etc/portage" do
  owner "root"
  group "portage"
  mode "0770"
end

directory "/var/log/portage" do
  owner "portage"
  group "portage"
  mode "2770"
end

directory "/var/log/portage/elog" do
  owner "portage"
  group "portage"
  mode "2770"
end

%w(keywords mask unmask use).each do |d|
  bash "convert_package_#{d}_to_file" do
    only_if { File.file?("/etc/portage/package.#{d}") }
    user "root"
    cwd "/etc/portage"
    code <<-EOC
    mv package.#{d} _package.#{d}
    mkdir package.#{d}
    sort -n _package.#{d} | uniq | egrep -v '^\s*(\#|$)' | while read LINE
    do
      echo "$LINE" > package.#{d}/$(echo ${LINE} | sed 's, .*$,,' | \
        sed 's,[\./],-,g' | sed -r 's,[^a-z0-9_\-],,g')
    done
    rm _package.#{d}
    EOC
  end

  directory "/etc/portage/package.#{d}" do
    owner "root"
    group "portage"
    mode "0770"
  end
end
