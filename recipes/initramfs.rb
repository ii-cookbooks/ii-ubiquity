#
# Cookbook Name:: ii-ubiquity
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# We could modify them all here
template "/usr/share/ubiquity-slideshow/slides/welcome.html" do
  source "slideshow/welcome.html.erb"
end

# http://www.wallz.eu/download/118478/SwedishChef
cookbook_file "/usr/share/backgrounds/warty-final-ubuntu.png" do
  source "swedishChef.png"
end

# service 'network-manager' do
#   action :nothing
# end

# We could put networks in a databag
# ['dd-wrt'].each do |ssid|
if node['ii-ubiquity']['wifi']['open']
  node['ii-ubiquity']['wifi']['open'].keys.each do |ssid|
    template "/etc/NetworkManager/system-connections/#{ssid}" do
      mode 0600
      source "nm-open-wifi.erb"
      variables({
          ssid: ssid
        })
      # network-manager can't be restarted... as we are only a chroot at this point
      # notifies :restart, 'service[network-manager]' #, :immediately # this happens so early can just que it
    end
  end
end
if node['ii-ubiquity']['wifi']['wpa']
  node['ii-ubiquity']['wifi']['wpa'].keys.each do |ssid|
    template "/etc/NetworkManager/system-connections/#{ssid}" do
      mode 0600
      source "nm-closed-wifi.erb"
      variables({
          ssid: ssid,
          psk: node['ii-ubiquity']['wifi']['wpa'][ssid]
        })
      # notifies :restart, 'service[network-manager]'#, :immediately # this happens so early can just que it
    end
  end
end
