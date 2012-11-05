#!/usr/bin/env ruby

GEM_INSTALL_CMD = "gem install %s"

INSTALL_GEMS = [
	"bundler",
	"git-issue",
	"jist",
	"hub",
	"milkode",
	"sc2epub"
]

INSTALL_GEMS.each do |gem_name|
  %x[#{sprintf(GEM_INSTALL_CMD, gem_name)}]
end
