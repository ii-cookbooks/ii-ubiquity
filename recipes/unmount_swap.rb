# Ubiquity seems to want to mount swap partitions
# Let's unmount them before the partitioner runs

swap_partitions = open(
  '/proc/swaps').lines.grep(
  /partition/).map{ |l|
  l.split.first}

swap_partitions.each do |partition|
  log "Can some one tell me WHY ubuntu activated this swap?: #{partition}"
  execute "swapoff #{partition}"
end
