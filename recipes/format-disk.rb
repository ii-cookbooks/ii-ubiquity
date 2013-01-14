case node['dmi']['system']['product_name']
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
when 'MacBookAir4,2' # W520s need nox2apic and nvidia
  # this has internal ssd at /dev/sda... should be gpt
  # This is bad, I'm just putting this in for a demo
  execute "parted -s /dev/sda mklabel gpt" do
    only_if do
      # we are on my MacBook Air
      node['dmi']['system']['serial_number'] == 'C02G62M8DJWR'
    end
  end
end
