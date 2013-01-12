#
# Author:: Troy Germain (<troy.germain@gmail.com>)
# Copyright:: Copyright (c) 2012
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# https://github.com/bigbosst/ohaiplugins

require 'mixlib/shellout'
provides "pci/devices"

pci Mash.new

# PCI ID / TYPE / VENDOR / DEVICE NAME / -rREVISION / SUBVENDOR / SUBSYSTEM NAME
re=Regexp.new("(.*) \"(.*)\" \"(.*)\" \"(.*)\" -r(.*) \"(.*)\" \"(.*)\"")

devices=Array.new

if File.exists?("/usr/bin/lspci")
  Mixlib::ShellOut.new("/usr/bin/lspci -m").run_command.stdout.each_line do |line|
    data=re.match(line)
    if data then
d=Hash.new
d[:devicename] = data[4]
d[:vendor] = data[3]
d[:subvendor] = data[6]
d[:pciid] = data[1]
d[:type] = data[2]
d[:revision] = data[5]
d[:subsystem] = data[7]
      devices.push(d)
end
  end
  pci[:devices]=devices
else
  Ohai::Log.debug("Skipping PCI, cannot find /usr/bin/lspci")
end


# I had it organized a different way, but I like bigbosst approach
# provides 'lspci'

# lspci Mash.new
# 'lspci').run_command.stdout.lines.to_a.map do |l|
#   l.strip.match /(..:..\..) (.*\s.*): (.*)/
# end.map do |m|
#   next if not m
#   if not lspci[m[2]]
#     lspci[m[2]] = Mash.new
#   end
#   lspci[m[2]][m[3]] = m[1]
# end
