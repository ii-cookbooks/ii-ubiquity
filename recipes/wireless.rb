# network-manager can't be restarted when in initramfs chroot...
# upstart doesn't work in a chroot
# however this would work once this is the real rootfs
# 
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
