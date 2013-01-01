#
# Cookbook Name:: ii-ubiquity
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/usr/share/ubiquity-slideshow/slides/usc.html" do
  source "slideshow/usc.html.erb"
end
