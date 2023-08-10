lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-ucam-raven/version'

Gem::Specification.new do |s|
  s.name          = 'omniauth-ucam-raven'
  s.version       = Omniauth::UcamRaven::VERSION
  s.license       = 'MIT'
  s.summary       = "OmniAuth strategy for Cambridge University's Raven SSO system"
  s.description   = 'This Ruby gem provides an OmniAuth strategy for authenticating using the Raven SSO System, provided by the University of Cambridge, or any other system implementing the Ucam-WebAuth protocol such as the SRCF Goose login service.'
  s.authors       = ['Charlie Jonas']
  s.email         = ['charlie@charliejonas.co.uk']
  s.homepage      = 'https://github.com/CHTJonas/omniauth-ucam-raven'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'omniauth', '~> 2.1'
  s.add_development_dependency 'bundler', '~> 2.0'
end
