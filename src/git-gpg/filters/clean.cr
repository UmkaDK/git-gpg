module GitGPG
  module Filters
    module Clean
      extend self

      def main(args)
        puts "Filter: #{File.basename(__FILE__, ".cr")}"
        puts "Args: #{args}"
      end
    end
  end
end