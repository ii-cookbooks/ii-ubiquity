#
# Cookbook Name:: ii-ubiquity
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "#{cookbook_name}::ohai-plugins"
# why Ubiquity mounts swap on disks it might be partitioning is beyond me...
include_recipe "#{cookbook_name}::unmount-swap"
include_recipe "#{cookbook_name}::format-disk"
