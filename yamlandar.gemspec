Gem::Specification.new do |s|
  s.name        = 'yamlandar'
  s.version     = '1.0.10'
  s.date        = '2016-06-18'
  s.summary     = "Hola!"
  s.description = "A simple yaml-to-html previewer"
  s.authors     = ["Nick Olds", "Jesse Shawl"]
  s.email       = 'olds.solutions@gmail.com'
  s.files       = ["lib/yamlandar.rb","lib/views/index.erb","lib/public/jquery.sticky.js"]
  s.add_runtime_dependency 'sinatra', '~> 1.4'
  s.executables << 'yamlandar'
  s.homepage    =
    'http://rubygems.org/gems/yamlandar'
  s.license       = 'MIT'
end
