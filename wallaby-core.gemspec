# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wallaby/core/version'

Gem::Specification.new do |spec|
  spec.name          = 'wallaby-core'
  spec.version       = Wallaby::Core::VERSION
  spec.authors       = ['Tian Chen']
  spec.email         = ['me@tian.im']
  spec.license       = 'MIT'

  spec.summary       = %q{The core of Wallaby}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/wallaby-rails/wallaby-core'

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'changelog_uri' => "#{spec.homepage}/blob/master/CHANGELOG.md"
  }

  spec.files = Dir[
    '{app,lib}/**/*',
    'LICENSE',
    'README.md'
  ]
  spec.test_files = Dir['spec/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 4.2.0'
  spec.add_dependency 'parslet'
  spec.add_dependency 'responders'
end
