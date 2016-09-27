require 'shell_mock'
require 'shell_mock/rspec/matchers/commmand_matcher'

module WebMock
  module Matchers
    def have_been_called
      ShellMock::CommandMatcher.new
    end

    def have_not_been_called
      ShellMock::CommandMatcher.new.times(0)
    end
  end
end
