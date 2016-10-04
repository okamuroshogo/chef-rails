#
# Cookbook Name:: wrapper_ikemen_cookbook
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# for rbenv
node.set["rbenv"]["ruby"]["versions"] = ["2.2.2","2.2.4"]
node.set["rbenv"]["ruby"]["global"] = "2.2.4"
 
# recipes
include_recipe "rbenv"
