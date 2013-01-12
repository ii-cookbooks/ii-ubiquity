# ISSUE: update-grub fails with error: cannot find device for / (is /dev mounted?
# PROBLEM: needs /dev/sdX to exists
# FIX: MAKEDEV
execute 'MAKEDEV sd' do # for some reason /dev isn't fully populated yet
  creates '/dev/sda'
  cwd '/dev'
end

# ISSUE: on reboot when grub loads you get ar error "Sparce file not allowed"
# PROBLEM: Grub's btrfs implementation is broken... if /boot is mounted as btrfs
#          Basically the environment block not implemented on btrfs
# http://askubuntu.com/questions/100329/message-sparse-file-not-allowed-after-succesfull-install-without-swap-partitio
# QUICKFIX: comment out use of the environment block
# LONGTERMFIX: https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/736743

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
  notifies :run, 'execute[update-grup]'
end

execute 'update-grub' do
 action :nothing
 # subscribes :run, 'ruby_block[edit etc grub.d 00_header]'
end

