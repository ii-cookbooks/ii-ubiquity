# If we want to load our ohai_plugins via the ohai::default recipe
# we do it this way, however we must include this recipe if we want these plugins to load
node.set['ohai']['plugins'][cookbook_name] = 'ohai_plugins'
include_recipe 'ohai'

# although I thought about actually installing them into the gem dir

# # I suppose we could just peek into our own directory and grab the list
# # but I'll leave it static for now
# plugins = %w{ pci }

# # node.default['ohai']['plugin_path'] = 
# plugins.each do |plugin|

#   ohai "reload_#{plugin}" do
#     action :nothing
#     plugin plugin
#   end
  
#   cookbook_file "#{}/#{plugin}.rb" do
#     source "ohai_plugins/#{plugin}.rb"
#     owner "root"
#     group "root"
#     mode 0755
#     notifies :reload, "ohai[reload_#{plugin}]", :immediately
#   end

# end

