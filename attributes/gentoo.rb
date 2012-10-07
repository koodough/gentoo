default['gentoo']['accept_licenses'] = ["*"]
default['gentoo']['cflags'] = "-march=native -O2 -pipe"
default['gentoo']['cxxflags'] = "${CFLAGS}"
default['gentoo']['distdir'] = "${PORTDIR}/distfiles"
default['gentoo']['distfile_mirrors'] = ["http://gentoo.osuosl.org/"]
default['gentoo']['ebeep_ignore'] = "yes"
default['gentoo']['elog_classes'] = %w(warn error log)
default['gentoo']['elog_mailfrom'] = "portage@#{node['fqdn']}"
default['gentoo']['elog_mailsubject'] = "[portage] ebuild log for ${PACKAGE} on ${HOST}"
default['gentoo']['elog_mailuri'] = "" # "foo@example.com smtp.example.com"
default['gentoo']['emerge_options'] = ["--verbose"] # + ["--jobs=3", "--load-average=3"]
default['gentoo']['hwtimezone'] = "UTC" # "local"
default['gentoo']['locales'] = ["en_US ISO-8859-1", "en_US.UTF-8 UTF-8"]
default['gentoo']['makeopts'] = "-j#{(node['cpu']['total'].to_i*2)+1}"
default['gentoo']['overlay_directories'] = []
default['gentoo']['pkgdir'] = "${PORDDIR}/packages/${ARCH}"
default['gentoo']['port_logdir'] = "/var/lgo/portage"
default['gentoo']['portage_binhost'] = ""
default['gentoo']['portage_features'] = %w(collision-protect noinfo parallel-fetch preserve-libs sfperms strict unmerge-orphans userpriv usersandbox buildpkg)
default['gentoo']['portdir'] = "/usr/portage"
default['gentoo']['profile'] = case node['kernel']['machine']
  when "x86_64"
    "default/linux/amd64/10.0"
  else
    "default/linux/#{node['kernel']['machine']}/10.0"
  end
default['gentoo']['rsync_mirror'] = "rsync://rsync.gentoo.org/gentoo-portage"
default['gentoo']['ruby_targets'] = ["ruby18"]
default['gentoo']['synchwclock'] = true # false
default['gentoo']['sysctl'] = {
  "kernel.panic" => 60,
  "kernel.shmmax" => 83886080,
  "net.ipv4.conf.all.rp_filter" => 1,
  "net.ipv4.conf.default.accept_redirects" => 0,
  "net.ipv4.conf.default.accept_source_route" => 0,
  "net.ipv4.conf.default.log_martians" => 1,
  "net.ipv4.conf.default.rp_filter" => 1,
  "net.ipv4.icmp_echo_ignore_broadcasts" => 1,
  "net.ipv4.icmp_ignore_bogus_error_responses" => 1,
}
default['gentoo']['timezone'] = "UTC" # "Europe/Budapest"
default['gentoo']['use_flags'] = [
  "-*", "berkdb", "bzip2", "cracklib", "crypt", "cxx", "fam", "gdbm",
  "glibc-omitfp", "gnutls", "iconv", "idn", "mmx", "modules", "mudflap",
  "multilib", "ncurses", "nls", "nptl", "nptlonly", "openmp", "pam",
  "pcre", "posix", "readline", "ruby", "sse", "sse2", "ssl", "sysfs",
  "sysvipc", "threads", "threadsafe", "unicode", "urandom", "xml", "zlib"
]
default['gentoo']['use_expands'] = {}
