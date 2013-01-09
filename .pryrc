require 'rubygems' if RUBY_VERSION < '1.9'
require 'awesome_print'
require 'interactive_editor'

Pry.print = proc{|output,value| output.puts value.ai }

Pry.config.color = true

