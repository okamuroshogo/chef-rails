#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w(gcc openssl-devel readline-devel git).each do |pkg|
  package pkg do
    action :install
  end
end

git "/home/#{node['ruby-env']['user']}/.rbenv" do
  repository node['ruby-env']['rbenv_url']
  reference 'master'
  action :sync
  group node['ruby-env']['group']
  user node['ruby-env']['user']
end

# bash_profileが他のレシピでも変更されている場合は、このやり方だとダメ
template '.bash_profile' do
  source 'bash_profile.erb'
  path "/home/#{node['ruby-env']['user']}/.bash_profile"
  mode '0644'
  owner node['ruby-env']['user']
  group node['ruby-env']['group']
  not_if "grep rbenv /home/#{node['ruby-env']['user']}/.bash_profile"
end

directory "/home/#{node['ruby-env']['user']}/.rbenv/plugins" do
  owner node['ruby-env']['user']
  group node['ruby-env']['group']
  mode '0755'
  action :create
end

%w(ruby-build rbenv-default-gems rbenv-gem-rehash).each do |plgin|
  git "/home/#{node['ruby-env']['user']}/.rbenv/plugins/#{plgin}" do
    repository node['ruby-env']["#{plgin}_url"]
    reference 'master'
    action :sync
    group node['ruby-env']['group']
    user node['ruby-env']['user']
  end
end

template 'default-gems' do
  source 'default-gems.erb'
  path "/home/#{node['ruby-env']['user']}/.rbenv/default-gems"
  mode '0755'
  owner node['ruby-env']['user']
  group node['ruby-env']['group']
  not_if { File.exists?("/home/#{node['ruby-env']['user']}/.rbenv/default-gems") }
end

execute "rbenv install #{node['ruby-env']['version']}" do
  command "/home/#{node['ruby-env']['user']}/.rbenv/bin/rbenv install #{node['ruby-env']['version']}"
  environment 'HOME' => "/home/#{node['ruby-env']['user']}"
  user node['ruby-env']['user']
  group node['ruby-env']['group']
  not_if { File.exists?("/home/#{node['ruby-env']['user']}/.rbenv/versions/#{node['ruby-env']['version']}") }
end

execute "rbenv global #{node['ruby-env']['version']}" do
  command "/home/#{node['ruby-env']['user']}/.rbenv/bin/rbenv global #{node['ruby-env']['version']}"
  environment 'HOME' => "/home/#{node['ruby-env']['user']}"
  user node['ruby-env']['user']
  group node['ruby-env']['group']
  not_if "grep #{node['ruby-env']['version']} /home/#{node['ruby-env']['user']}/.rbenv/version"
end

#execute 'change owner and mode' do
#  not_if "ls -ld /usr/local/rbenv/versions | awk '{ print $4 }' | grep rbenv"
#  command 'chown -R vagrant:vagrant /usr/local/rbenv'
#end
