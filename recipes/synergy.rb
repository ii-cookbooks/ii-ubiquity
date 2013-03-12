# do fun ingredient stuff later... quick and dirty for demo:
dpkg_package 'synergy' do
  source ::File.join(Chef::Config[:file_cache_path],'synergy-1.4.10-Linux-x86_64.deb')
end

node.default['synergy']['server']=nil

if node['synergy']['server']
  # don't start anything too early, as the disk partitioner will hang
  #execute "synergyc --display :0.0 #{node['synergy']['server']}&"
  #execute "nohup synergyc --display :0.0 #{node['synergy']['server']}"
  # cheating by using at to start it within the next minute
  # give it a uniq name so we could connect multiple machines
  # the synergy server will show the name of nodes trying to connect
  execute "echo synergyc --display :0.0 #{node['synergy']['server']} --name #{node['dmi']['sytem']['product_name'].gsub(/(,|\,|\ )/,'-')}_#{node['dmi']['sytem']['serial_number'].gsub(/(,|\,|\ )/,'-')} | at now + 1 minute"
end


