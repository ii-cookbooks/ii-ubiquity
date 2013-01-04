#
# Cookbook Name:: ii-ubiquity
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# W520s need nox2apic and nomodeset
case %x{dmidecode -s system-version}.chomp
when /ThinkPad W520/
  ruby_block "edit etc default grub" do
    block do
      rc = Chef::Util::FileEdit.new("/etc/default/grub")
      rc.search_file_replace_line(
        /^GRUB_CMDLINE_LINUX_DEFAULT=/,
      'GRUB_CMDLINE_LINUX_DEFAULT="nox2apic"' #nomodeset may be needed
        )
      rc.write_file
    end
  end
  package 'nvidia-current-updates'
  package 'nvidia-settings-updates'
end

# Guess we will have to put up with the no sparce file allowed error for now

#ISSUE: update-grub fails with error: cannot find device for / (is /dev mounted?
#PROBLEM: needs /dev/sdX to exists
#FIX: MAKEDEV
execute 'MAKEDEV sd' do # for some reason /dev isn't fully populated yet
  creates '/dev/sda'
  cwd '/dev'
end
execute 'update-grub' do
 action :nothing
 subscribes :run, 'ruby_block[edit etc grub.d 00_header]'
end

# http://askubuntu.com/questions/100329/message-sparse-file-not-allowed-after-succesfull-install-without-swap-partitio
ruby_block "edit etc grub.d 00_header" do
  block do
    # Because Chef::Util::FileEdit drops a filename.bak file, we had to modify it
    rc = Chef::Util::FileEditNobak.new("/etc/grub.d/00_header")
    rc.search_file_replace_line(
      /have_grubenv}/,
      '#  if [ -n "\${have_grubenv}" ]; then if [ -z "\${boot_once}" ]; then save_env recordfail; fi; fi'
      )
    rc.write_file
  end
end

# I think these must go into the initrd
#file "/lib/plymouth/themes/ubuntu-logo/ubuntu_logo16.png"
#file "/lib/plymouth/themes/ubuntu-logo/ubuntu_logo.png"
# I'd like to be able to run-chef-solo as the normal user
template "/usr/local/bin/run-chef-solo" do
  source "run-chef-solo"
  mode 0755
end

