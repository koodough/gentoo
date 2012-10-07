define :generate_make_conf do
  Chef::Log.debug("Generating /etc/portage/make.conf: #{params['name']}")
  template "/etc/portage/make.conf" do
    source "make.conf.erb"
    cookbook "gentoo"
    owner "root"
    group "root"
    mode "0644"
    action :create
    variables(
      :cflags => node['gentoo']['cflags'],
      :chost => "#{node['kernel']['machine']}-pc-linux-gnu",
      :cssflags => node['gentoo']['cxxflags'],
      :distdir => node['gentoo']['distdir'],
      :distfile_mirrors => [node['gentoo']['distfile_mirrors']].flatten,
      :ebeep_ignore => node['gentoo']['ebeep_ignore'],
      :elog_classes => node['gentoo']['elog_classes'],
      :elog_mailfrom => node['gentoo']['elog_mailfrom'],
      :elog_mailsubject => node['gentoo']['elog_mailsubject'],
      :elog_mailuri => node['gentoo']['elog_mailuri'],
      :emerge_options => [node['gentoo']['emerge_options']].flatten,
      :features => [node['gentoo']['portage_features']].flatten,
      :licenses => [node['gentoo']['accept_licenses']].flatten,
      :makeopts => [node['gentoo']['makeopts']].flatten,
      :overlays => [node['gentoo']['overlay_directories']].flatten,
      :pkgdir => node['gentoo']['pkgdir'],
      :port_logdir => node['gentoo']['port_logdir'],
      :portage_binhost => node['gentoo']['portage_binhost'],
      :portage_niceness => node['gentoo']['portage_niceness'],
      :portdir => node['gentoo']['portdir'],
      :rsync_mirror => node['gentoo']['rsync_mirror'],
      :ruby_targets => [node['gentoo']['ruby_targets']].flatten,
      :use_expands => node['gentoo']['use_expands'],
      :use_flags => node['gentoo']['use_flags']
    )
  end
end
