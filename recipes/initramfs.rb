#
# Cookbook Name:: ii-ubiquity
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "#{cookbook_name}::ohai-plugins"
include_recipe "#{cookbook_name}::slideshow"
include_recipe "#{cookbook_name}::desktop"
include_recipe "#{cookbook_name}::wireless"


