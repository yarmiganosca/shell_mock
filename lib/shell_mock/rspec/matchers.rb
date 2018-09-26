require 'shell_mock/run_verifier'

module ShellMock
  module Matchers
    def have_run
      ShellMock::RunVerifier.new
    end
    alias have_been_called have_run
    alias have_ran have_run
  end
end
