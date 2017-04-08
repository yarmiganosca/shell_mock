require 'shell_mock'

require 'rspec/core'
require 'rspec/expectations'

require 'shell_mock/rspec/matchers'

RSpec.configure do |config|
  config.include ShellMock::Matchers
end
