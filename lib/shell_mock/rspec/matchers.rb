require 'shell_mock/call_verifier'

module ShellMock
  module Matchers
    def have_been_called
      ShellMock::CallVerifier.new
    end
  end
end
