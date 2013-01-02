# from Adam - https://gist.github.com/1185022 - https://gist.github.com/4384614
require 'fileutils'
class Chef
  class Util
    class FileEditNobak < Chef::Util::FileEdit
      #DO NOT Make a copy of old_file
      def write_file
        if file_edited
          # Our only change is to comment this out
          #backup_pathname = original_pathname + ".old"
          #FileUtils.cp(original_pathname, backup_pathname, :preserve => true)
          File.open(original_pathname, "w") do |newfile|
            contents.each do |line|
              newfile.puts(line)
            end
            newfile.flush
          end
        end
        self.file_edited = false
      end
    end
  end
end

