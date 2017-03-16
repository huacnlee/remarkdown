require "markdown"
require "./remarkdown/*"

module Remarkdown
  def self.parse(text, renderer, opts)
    parser = Remarkdown::Parser.new(text, renderer, opts)
    parser.parse
  end

  def self.to_html(text) : String
    self.to_html(text, {
      strikethrough:       true,
      space_after_headers: true,
    })
  end

  def self.to_html(text, opts) : String
    String.build do |io|
      parse text, Remarkdown::HTMLRenderer.new(io), opts
    end
  end
end
