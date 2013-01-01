#
# Cookbook Name:: ii-ubiquity
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/usr/share/ubiquity-slideshow/slides/welcome.html" do
  source "slideshow/welcome.html.erb"
end

# http://www.wallz.eu/download/118478/SwedishChef
cookbook_file "/usr/share/backgrounds/warty-final-ubuntu.png" do
  source "swedishChef.png"
end


service 'network-manager' do
  action :nothing
end

['dd-wrt'].each do |ssid|
  template "/etc/NetworkManager/system-connections/#{ssid}" do
    mode 0600
    source "nm-open-wifi.erb"
    variables({
      ssid: ssid
    })
    notifies :restart, 'service[network-manager]', :immediately
  end
end
