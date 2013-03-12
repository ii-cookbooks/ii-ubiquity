#
# Cookbook Name:: ii-ubiquity
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "#{cookbook_name}::ohai-plugins"
include_recipe "#{cookbook_name}::btrfs-grub"

# https://github.com/bigbosst/ohaiplugins#usage

video_cards = node['pci']['devices'].find_all {|d| d['type'] =~ /VGA compatible controller/}
#video_cards.detect {|vc| vc['vendor'] =~ /nvidia/i && vc['subvendor'] =~ /lenovo/i}

video_cards.each do |vc|
  case vc['vendor']
  when /nvidia/i
    # we also need internet to retrieve nvidia packages
    case vc['subvendor']
    when /lenovo/i
      package 'nvidia-current-updates'
      package 'nvidia-settings-updates'
    end
  end
end

begin
  # I'd like this logic to be in databags or attributes fully
  case node['dmi']['system']['family']
    #['dmi']['system']  also has these:
    #   "Product Name"=>"4270CTO",
    #   "manufacturer"=>"LENOVO",
    #   "serial_number"=>"R9NXPZ6",
    #   "uuid"=>"74FAF201-518E-11CB-B6EC-86481405DC76",
    #['dmi']['processor'] has these:
    #  "family"=>"Core i7",
    # "version"=>"Intel(R) Core(TM) i7-2860QM CPU @ 2.50GHz",
    # "max_speed"=>"2500 MHz",
    # "asset_tag"=>"9876543210",
    # "part_number"=>"CMSO8GX3M1A1333C9 ",
    # "core_count"=>"4",
    # "thread_count"=>"8",
    # "maximum_capacity"=>"32 GB",
    # "range_size"=>"32 GB",
  when /ThinkPad W520/ # W520s need nox2apic and nvidia
    ruby_block "edit etc default grub" do
      block do
        rc = Chef::Util::FileEdit.new("/etc/default/grub")
        rc.search_file_replace_line(
          /^GRUB_CMDLINE_LINUX_DEFAULT=/,
          'GRUB_CMDLINE_LINUX_DEFAULT="nox2apic"' #nomodeset may be needed on MacBookAir
          )
        rc.write_file
      end
      notifies :run, 'execute[update-grub]'
    end
  end
rescue
  "why this errors out with [] on a nil on case node['dmi']['system']['family'] baffles me"
end

# We can't customize the plymouth on the target this easily
# These files must be pulled into the initrd
#file "/lib/plymouth/themes/ubuntu-logo/ubuntu_logo16.png"
#file "/lib/plymouth/themes/ubuntu-logo/ubuntu_logo.png"

# I'd like to be able to run-chef-solo as the normal user
template "/usr/local/bin/run-chef-solo" do
  source "run-chef-solo.erb"
  mode 0755
end

include_recipe "#{cookbook_name}::synergy"
