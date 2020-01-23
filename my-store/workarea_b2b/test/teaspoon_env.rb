require 'workarea/testing/teaspoon'

Teaspoon.configure do |config|
  config.root = Workarea::B2b::Engine.root
  Workarea::Teaspoon.apply(config)
end
