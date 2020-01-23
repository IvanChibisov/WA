$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "workarea/b2b/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "workarea-b2b"
  s.version     = Workarea::B2b::VERSION
  s.authors     = ["Matt Duffy"]
  s.email       = ["mduffy@weblinc.com"]
  s.homepage    = "https://www.workarea.com"
  s.summary     = "Business to business plugin for the Workarea Commerce platform."
  s.description = "Business to business plugin for the Workarea Commerce platform."

  s.files = `git ls-files`.split("\n")

  s.add_dependency 'workarea', '~> 3.x', '>= 3.4.x'
end
