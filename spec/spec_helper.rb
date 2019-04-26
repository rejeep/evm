require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'coveralls'

SimpleCov.formatters = [
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
]

SimpleCov.start do
  add_filter 'spec'
  track_files 'lib/**/*.rb'
end

require 'evm'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.before do
    allow(Evm).to receive(:config).and_return({path: '/tmp/evm'})
  end
end
