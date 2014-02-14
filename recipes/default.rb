#
# Cookbook Name:: mirthconnect
# Recipe:: default
#
# Copyright 2014, Diagnotes, Inc.
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


# Install Dependencies

execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    !File.exists?('/var/lib/apt/periodic/update-success-stamp') ||
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end

package "openjdk-7-jdk"


# Setup User/Group/Directory structure
group node[:mirthconnect][:group]

user node[:mirthconnect][:user] do
  supports :manage_home => true
  gid node[:mirthconnect][:group]
  comment "Mirth Connect"
  home node[:mirthconnect][:homedir]
  shell "/bin/bash"
end

directory node[:mirthconnect][:homedir] do
  owner node[:mirthconnect][:user]
  group node[:mirthconnect][:group]
  recursive true
  mode 00700
end


# Download and setup Mirth
downloaded_archive = "#{node[:mirthconnect][:homedir]}/#{node[:mirthconnect][:download_file]}"
remote_file downloaded_archive do
  user node[:mirthconnect][:user]
  source node[:mirthconnect][:download_url]
  not_if { File.exists? downloaded_archive }
end

execute "untar-mirth" do
  user node[:mirthconnect][:user]
  cwd node[:mirthconnect][:homedir]
  command "tar xzf #{downloaded_archive}"
  creates "#{node[:mirthconnect][:homedir]}/Mirth Connect"
end

# Setup the service
template "/etc/init/mirthconnect.conf" do
  source "mirthconnect.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :user => node[:mirthconnect][:user],
    :group => node[:mirthconnect][:group],
    :mirthdir => "#{node[:mirthconnect][:homedir]}/Mirth Connect"
  })
end

service "mirthconnect" do
  provider Chef::Provider::Service::Upstart
  action :start
end
