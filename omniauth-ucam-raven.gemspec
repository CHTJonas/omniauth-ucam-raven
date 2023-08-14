lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-ucam-raven/version'

Gem::Specification.new do |s|
  spec.name          = 'omniauth-ucam-raven'
  spec.version       = Omniauth::UcamRaven::VERSION
  spec.license       = 'MIT'
  spec.summary       = "OmniAuth strategy for Cambridge University's Raven SSO system"
  spec.description   = 'This Ruby gem provides an OmniAuth strategy for authenticating using the Raven SSO System, provided by the University of Cambridge, or any other system implementing the Ucam-WebAuth protocol such as the SRCF Goose login service.'
  spec.authors       = ['Charlie Jonas']
  spec.email         = ['charlie@charliejonas.co.uk']
  spec.homepage      = 'https://github.com/CHTJonas/omniauth-ucam-raven'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'omniauth', '~> 2.1'
  spec.add_development_dependency 'bundler', '~> 2.0'

  spec.metadata = {
    'homepage_uri'      => 'https://github.com/CHTJonas/omniauth-ucam-raven',
    'bug_tracker_uri'   => 'https://github.com/CHTJonas/omniauth-ucam-raven/issues',
    'changelog_uri'     => 'https://github.com/CHTJonas/omniauth-ucam-raven/blob/main/CHANGELOG.md',
    'source_code_uri'   => 'https://github.com/CHTJonas/omniauth-ucam-raven'
  }
end
