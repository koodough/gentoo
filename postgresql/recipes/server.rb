#/postgresql.conf.
# Cookbook Name:: postgresql
# Recipe:: server
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Lamont Granquist (<lamont@opscode.com>)
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if Chef::Config[:solo]
  def secure_password
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    (0..50).map{ o[rand(o.length)] }.join
  end
else
  ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
end
include_recipe "postgresql::client"

# randomly generate postgres password
node.set_unless[:postgresql][:password][:postgres] = secure_password
node.save unless Chef::Config[:solo]

case node[:postgresql][:version]
when "8.3"
  node.default[:postgresql][:ssl] = "off"
when "8.4"
  node.default[:postgresql][:ssl] = "true"
end

# Include the right "family" recipe for installing the server
# since they do things slightly differently.
case node.platform
when "gentoo"
  include_recipe "postgresql::server_gentoo"
when "redhat", "centos", "fedora", "suse", "scientific", "amazon"
  include_recipe "postgresql::server_redhat"
when "debian", "ubuntu"
  include_recipe "postgresql::server_debian"
end

template "#{node[:postgresql][:conf_dir]}/pg_hba.conf" do
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :reload, resources(:service => "postgresql"), :immediately
end

bash "run-postgres-server" do
  user 'root'
  code <<-EOH
/etc/init.d/postgresql-#{node[:postgresql][:version][0..2]} start
rc-update add postgresql-#{node[:postgresql][:version][0..2]} default
  EOH
  action :run
end

# Default PostgreSQL install has 'ident' checking on unix user 'postgres'
# and 'md5' password checking with connections from 'localhost'. This script
# runs as user 'postgres', so we can execute the 'role' and 'database' resources
# as 'root' later on, passing the below credentials in the PG client.
bash "assign-postgres-password" do
  user 'postgres'
  code <<-EOH
echo "ALTER ROLE postgres ENCRYPTED PASSWORD '#{node[:postgresql][:password][:postgres]}';" | psql
  EOH
  not_if do
    begin
      require 'rubygems'
      Gem.clear_paths
      require 'pg'
      conn = PGconn.connect("localhost", 5432, nil, nil, nil, "postgres", node['postgresql']['password']['postgres'])
    rescue PGError
      false
    end
  end
  action :run
end
