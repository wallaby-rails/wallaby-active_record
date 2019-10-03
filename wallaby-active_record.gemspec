# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wallaby/active_record/version'

Gem::Specification.new do |spec|
  spec.name          = 'wallaby-active_record'
  spec.version       = Wallaby::ActiveRecord::VERSION
  spec.authors       = ['Tian Chen']
  spec.email         = ['me@tian.im']
  spec.license       = 'MIT'

  spec.summary       = %q{Wallaby's ActiveRecord ORM adapter}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/wallaby-rails/wallaby-active_record'

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

  spec.add_dependency 'wallaby-core'
  spec.add_dependency 'kaminari'
end
