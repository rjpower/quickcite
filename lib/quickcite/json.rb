# JSON utilities.
require "json"

module QuickCite
  module JSONUtil
    class JSONDict
      extend Forwardable
      include Enumerable
      attr_reader :dict
      
      def initialize(d)
        @dict = d
      end
      
      def method_missing name, *args
        return JSONUtil._wrap(@dict[name.to_s])
      end
      
      def [](key)
        JSONUtil._wrap(@dict[key])
      end
      
      def each
        case @dict
          when Hash
            @dict.each_key { |k| yield self[k] }
          when Array
            @dict.each_index { |k| yield self[k] }
         end
      end
    end

    def self._wrap(value)
      case value
        when Hash, Array
          JSONDict.new(value)
        else
          value
        end
    end
 
    def self.parse(str)
      d = JSONDict.new(JSON.parse(str))
    end
  end
end