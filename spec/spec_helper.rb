require 'rubygems'
require 'bundler/setup'
require 'simplecov'

if ENV['TRAVIS']
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
else
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
end

SimpleCov.start do
  add_filter 'spec'
end

evm_lib = File.expand_path('../../lib', __FILE__)
# Eager load the entire lib directory so that SimpleCov is able to report accurate code coverage metrics.
at_exit { Dir["#{evm_lib}/**/*.rb"].each { |rb| require(rb) } }
$LOAD_PATH.unshift evm_lib
require 'evm'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.before do
    allow(Evm).to receive(:config).and_return({path: '/tmp/evm'})
  end
end
