lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invisible_collector/version'

Gem::Specification.new do |spec|
  spec.name          = 'invisible_collector'
  spec.version       = InvisibleCollector::VERSION
  spec.authors       = ['João Madureira']
  spec.email         = ['jmadureira@invisiblecollector.com']

  spec.summary       = 'Official Invisible Collector Gem'
  spec.description   = 'Official Invisible Collector Gem used to interact with Invisible Collector API in ruby'
  spec.homepage      = 'https://github.com/invisiblecloud/invisible-collector-ruby'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '> 3.0', '< 6'
  spec.add_dependency 'faraday', '>= 0.9'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.60'
  spec.add_development_dependency 'simplecov', '~> 0.15'
  spec.add_development_dependency 'webmock', '~> 3.1'
end
