module Remarkdown
  class HTMLRenderer
    def initialize(@io : IO)
    end

    def begin_header_with_id(level, line)
      @io << "<h"
      @io << level
      heading_id = line.underscore.gsub(/[#?&_\s]+/, "-")
      @io << " id=\"#{heading_id}\">"
    end

    def begin_strikethrough
      @io << "<del>"
    end

    def end_strikethrough
      @io << "</del>"
    end
  end
end
