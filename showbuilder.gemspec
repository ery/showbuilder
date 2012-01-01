Gem::Specification.new do |s|
  s.name          = 'showbuilder'
  s.version       = '0.0.2'
  s.date          = '2011-12-07'
  s.summary       = 'A Rails View Helper.'
  s.description   = 'A Rails View Helper. Show model/s as view, form, list.'
  s.authors       = ['Ery wang']
  s.email         = 'ery@baoleihang.com'
  s.homepage      = 'https://github.com/ery/showbuilder'
  s.files         = Dir['lib/*', 'lib/**/*']
  s.require_paths = ['lib']
  s.add_dependency 'actionpack',    '~> 3.0'
  s.add_dependency 'will_paginate', '~> 3.0'
end


