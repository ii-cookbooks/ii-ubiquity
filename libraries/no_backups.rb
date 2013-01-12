# I'd live to figure out how reopen the file and template resources to disable backups
class Chef
  class Resource
    class File
      def initialize(name, run_context=nil)
        super
        @resource_name = :file
        @path = name
        @backup = false
        @action = "create"
        @allowed_actions.push(:create, :delete, :touch, :create_if_missing)
        @provider = Chef::Provider::File
        @diff = nil
      end
    end
  end
end

class Chef
  class Resource
    class Template
      def initialize(name, run_context=nil)
        super
        @resource_name = :template
        @action = "create"
        @source = "#{::File.basename(name)}.erb"
        @cookbook = nil
        @local = false
        @variables = Hash.new
        @provider = Chef::Provider::Template
        @backup = false
      end
    end
  end
end
