#
# Cookbook Name:: create-user
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
group "app_group" do
  gid 1000
  action :create
end

user "app_user" do
  home "/home/app_user"
  password "$6$yQgAeFK+lowV65wP$3WMfT0f0u0c2gToAg9kZSc5PpEyknJgvjZTYlx2AkTdh3F8FWIT9HPXrXtn6Q1vz52kad/uKa1gdvEQfFXOIp."
  shell "/bin/bash"
  uid 1000
  gid "app_group"
  action :create
end
