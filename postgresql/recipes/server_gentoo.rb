#
# Cookbook Name:: postgresql
# Recipe:: server
#
# Author:: Marcin Nowicki (<pr0d1r2@gmail.com>)#
# Copyright 2011, DoubleDrones
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

include_recipe "postgresql::client"

case node[:postgresql][:version]
when "8.3"
  node.default[:postgresql][:ssl] = "off"
else # > 8.3
  node.default[:postgresql][:ssl] = "true"
end

package "postgresql-server" do
  action :upgrade
end

service "postgresql" do
  service_name "postgresql-#{node[:postgresql][:version][0..2]}"
  supports :restart => true, :status => true, :reload => true
  action :nothing
end

execute "configure database" do
  user "root"
  command "echo 'y' | emerge --config =dev-db/postgresql-server-#{node[:postgresql][:version]}"
end
