#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
template "/etc/yum.repos.d/nginx.repo" do
  mode 0644
  user 'root'
  group 'root'
end

yum_package "nginx" do
  action :install
  flush_cache [:before]
end

service "nginx" do
  action [:start, :enable]
  supports status: true, restart: true, reload: true
end

