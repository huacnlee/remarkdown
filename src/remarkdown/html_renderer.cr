require "./renderer"

module Remarkdown
  class HTMLRenderer < Markdown::HTMLRenderer
    include Remarkdown::Renderer

    def begin_header_with_id(level, line)
      @io << "<h"
      @io << level
      @io << " id=\"#{line}\">"
    end

    # def begin_strikethrough
    # end
    #
    # def end_strikethrough
    # end
  end
end
