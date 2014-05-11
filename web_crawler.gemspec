$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "web_crawler/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "web_crawler"
  s.version     = WebCrawler::VERSION
  s.authors     = ["Tiago Scolari"]
  s.email       = ["tscolari@gmail.com"]
  s.homepage    = "http://dev.tscolari.me"
  s.summary     = "Simple site mapper generator"
  s.description = "Generates a site map to a given url"
  s.license     = "MIT"
  s.executables = ["site_mapper"]

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "activesupport"
  s.add_dependency "nokogiri"

  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "webmock"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "pry-byebug"

end
