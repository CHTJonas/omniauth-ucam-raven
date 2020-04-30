lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-ucam-raven/version'

Gem::Specification.new do |s|
  s.name          = 'omniauth-ucam-raven'
  s.version       = Omniauth::UcamRaven::VERSION
  s.license       = 'MIT'
  s.summary       = "An OmniAuth strategy for Cambridge University's Raven SSO system"
  s.description   = "An OmniAuth strategy for Cambridge University's Raven SSO system"
  s.authors       = ['Charlie Jonas']
  s.email         = ['devel@charliejonas.co.uk']
  s.homepage      = 'https://github.com/CHTJonas/omniauth-ucam-raven'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'omniauth', '~> 1.0'
  s.add_development_dependency 'bundler', '~> 2.0'
end
