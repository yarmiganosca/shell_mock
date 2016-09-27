require 'shell_mock'

require 'rspec/core'
require 'rspec/expectations'

require 'shell_mock/rspec/matchers'

ShellMock.enable
ShellMock.dont_let_commands_run

RSpec.configure do |config|
  config.include ShellMock::Matchers
end
