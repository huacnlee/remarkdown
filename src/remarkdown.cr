require "markdown"
require "./remarkdown/*"

module Remarkdown
  def self.parse(text, io)
    parser = Remarkdown::Parser.new(text, io)
    parser.parse
  end

  def self.to_html(text) : String
    String.build do |io|
      parse text, io
    end
  end
end
