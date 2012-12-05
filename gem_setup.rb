#!/usr/bin/env ruby

GEM_INSTALL_CMD = "gem install %s"

INSTALL_GEMS = [
	"awesome_print",
	"cheat",
	"bundler",
	"git-browse-remote",
	"git-issue",
	"jist",
	"hub",
	"milkode",
  "pry",
	"rdoc-view",
	"redcarpet",
	"sc2epub"
]

INSTALL_GEMS.each do |gem_name|
  %x[#{sprintf(GEM_INSTALL_CMD, gem_name)}]
end
