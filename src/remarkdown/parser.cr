module Remarkdown
  class Parser < Markdown::Parser
    def initialize(text : String, @renderer : Renderer, options)
      @options = options || {
        strikethrough:       true,
        space_after_headers: true,
      }
      @lines = text.lines
      @line = 0
    end

    def process_paragraph
      line = @lines[@line]

      case item = classify(line)
      when :empty
        @line += 1
      when :header1
        render_header 1, line, 2
      when :header2
        render_header 2, line, 2
      when PrefixHeader
        render_prefix_header(item.count, line)
      when :code
        render_code
      when :horizontal_rule
        render_horizontal_rule
      when UnorderedList
        render_unordered_list(item.char)
      when :fenced_code
        render_fenced_code
      when :ordered_list
        render_ordered_list
      when :quote
        render_quote
      else
        render_paragraph
      end
    end

    def classify1(line)
      nil
    end

    # Override count_pounds for Heading 1-6
    # Patch for
    #
    #   space_after_headers: true
    def count_pounds(line)
      unless @options[:space_after_headers]
        return super
      end

      bytesize = line.bytesize
      str = line.to_unsafe
      pos = 0
      while pos < bytesize && pos < 6 && str[pos].unsafe_chr == '#'
        pos += 1
      end
      return nil if pos == 0
      # last char
      return nil if pos === bytesize
      return if str[pos].unsafe_chr != ' ' && str[pos].unsafe_chr != '#'
      pos
    end

    def render_header(level, line, increment)
      @renderer.begin_header level
      process_line line
      @renderer.end_header level
      @line += increment

      append_double_newline_if_has_more
    end
  end
end
