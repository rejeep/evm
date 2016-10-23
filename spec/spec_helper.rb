require 'rubygems'
require 'bundler/setup'

require 'evm'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.before do
    allow(Evm).to receive(:config).and_return({path: '/tmp/evm'})
  end
end
