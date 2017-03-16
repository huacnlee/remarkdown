module Remarkdown::Renderer
  include Markdown::Renderer

  # abstract def emoji
  abstract def begin_header_with_id(level, line)
  # abstract def begin_strikethrough
  # abstract def end_strikethrough
end
