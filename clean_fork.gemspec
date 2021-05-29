$LOAD_PATH.unshift 'lib'
require 'clean_fork/version'

Gem::Specification.new do |s|
  s.name        = 'clean_fork'
  s.version     = CleanFork::VERSION
  s.summary     = "Clean forks of Ruby processes"
  s.description = "Manages clean forks of Ruby processes"
  s.authors     = ["Bing-Chang Lai"]
  s.email       = 'johnny.lai@me.com'
  s.files       = Dir["README.md", "MIT-LICENSE", "lib/**/*"]
  s.homepage    = 'https://rubygems.org/gems/clean_fork'
  s.license     = 'MIT'
end
