# frozen_string_literal: true

require_relative 'lib/stacking_order/version'

Gem::Specification.new do |spec|
  spec.name          = 'stacking-order'
  spec.version       = StackingOrder::VERSION
  spec.authors       = ['Jeremy']
  spec.email         = ['jeremy@example.com']

  spec.summary       = 'Compute cut-and-stack printing orders for grid-based badges.'
  spec.description   = 'A tiny utility that reorders records for stack-cut badge printing, available as both a Ruby library and a command-line tool.'
  spec.homepage      = 'https://github.com/jeremy/stacking-order'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  spec.required_ruby_version = Gem::Requirement.new('>= 3.1')

  spec.files         = Dir['lib/**/*', 'exe/*', 'README.md', 'LICENSE.txt', 'examples/**/*']
  spec.bindir        = 'exe'
  spec.executables   = ['stacking-order']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rake'
end
