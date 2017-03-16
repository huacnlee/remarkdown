module Remarkdown
  class Parser < Markdown::Parser
    def initialize(text : String, io : IO)
      @renderer = Markdown::HTMLRenderer.new(io)
      @gfm_renderer = Remarkdown::HTMLRenderer.new(io)

      @options = {
        strikethrough:       true,
        space_after_headers: true,
      }
      @lines = text.lines
      @line = 0
    end

    # Override `process_line` for paragraph features
    def process_line(line)
      bytesize = line.bytesize
      str = line.to_unsafe
      pos = 0

      while pos < bytesize && str[pos].unsafe_chr.ascii_whitespace?
        pos += 1
      end

      cursor = pos
      one_star = false
      two_stars = false
      one_underscore = false
      two_underscores = false
      one_backtick = false
      in_link = false
      last_is_space = true
      two_tildes = false

      while pos < bytesize
        case str[pos].unsafe_chr
        when '*'
          if pos + 1 < bytesize && str[pos + 1].unsafe_chr == '*'
            if two_stars || has_closing?('*', 2, str, (pos + 2), bytesize)
              @renderer.text line.byte_slice(cursor, pos - cursor)
              pos += 1
              cursor = pos + 1
              if two_stars
                @renderer.end_bold
              else
                @renderer.begin_bold
              end
              two_stars = !two_stars
            end
          elsif one_star || has_closing?('*', 1, str, (pos + 1), bytesize)
            @renderer.text line.byte_slice(cursor, pos - cursor)
            cursor = pos + 1
            if one_star
              @renderer.end_italic
            else
              @renderer.begin_italic
            end
            one_star = !one_star
          end
        when '_'
          if pos + 1 < bytesize && str[pos + 1].unsafe_chr == '_'
            if two_underscores || (last_is_space && has_closing?('_', 2, str, (pos + 2), bytesize))
              @renderer.text line.byte_slice(cursor, pos - cursor)
              pos += 1
              cursor = pos + 1
              if two_underscores
                @renderer.end_bold
              else
                @renderer.begin_bold
              end
              two_underscores = !two_underscores
            end
          elsif one_underscore || (last_is_space && has_closing?('_', 1, str, (pos + 1), bytesize))
            @renderer.text line.byte_slice(cursor, pos - cursor)
            cursor = pos + 1
            if one_underscore
              @renderer.end_italic
            else
              @renderer.begin_italic
            end
            one_underscore = !one_underscore
          end
        when '`'
          if one_backtick || has_closing?('`', 1, str, (pos + 1), bytesize)
            @renderer.text line.byte_slice(cursor, pos - cursor)
            cursor = pos + 1
            if one_backtick
              @renderer.end_inline_code
            else
              @renderer.begin_inline_code
            end
            one_backtick = !one_backtick
          end
        when '!'
          if pos + 1 < bytesize && str[pos + 1] === '['
            link = check_link str, (pos + 2), bytesize
            if link
              @renderer.text line.byte_slice(cursor, pos - cursor)

              bracket_idx = (str + pos + 2).to_slice(bytesize - pos - 2).index(']'.ord).not_nil!
              alt = line.byte_slice(pos + 2, bracket_idx)

              @renderer.image link, alt

              paren_idx = (str + pos + 2 + bracket_idx + 1).to_slice(bytesize - pos - 2 - bracket_idx - 1).index(')'.ord).not_nil!
              pos += 2 + bracket_idx + 1 + paren_idx
              cursor = pos + 1
            end
          end
        when '['
          unless in_link
            link = check_link str, (pos + 1), bytesize
            if link
              @renderer.text line.byte_slice(cursor, pos - cursor)
              cursor = pos + 1
              @renderer.begin_link link
              in_link = true
            end
          end
        when ']'
          if in_link
            @renderer.text line.byte_slice(cursor, pos - cursor)
            @renderer.end_link

            paren_idx = (str + pos + 1).to_slice(bytesize - pos - 1).index(')'.ord).not_nil!
            pos += paren_idx + 1
            cursor = pos + 1
            in_link = false
          end
        when '~'
          if pos + 1 < bytesize && str[pos + 1].unsafe_chr == '~'
            if two_tildes || has_closing?('~', 2, str, (pos + 2), bytesize)
              @renderer.text line.byte_slice(cursor, pos - cursor)
              pos += 1
              cursor = pos + 1
              if two_tildes
                @gfm_renderer.end_strikethrough
              else
                @gfm_renderer.begin_strikethrough
              end
              two_tildes = !two_tildes
            end
          end
        end
        last_is_space = pos < bytesize && str[pos].unsafe_chr.ascii_whitespace?
        pos += 1
      end

      @renderer.text line.byte_slice(cursor, pos - cursor)
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
      @gfm_renderer.begin_header_with_id level, line
      process_line line
      @renderer.end_header level
      @line += increment

      append_double_newline_if_has_more
    end
  end
end
