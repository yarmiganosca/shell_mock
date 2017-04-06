require 'shell_mock/call_verifier'

module ShellMock
  class CommandStub
    attr_reader :command, :expected_output, :exitstatus, :env, :options, :side_effect

    def initialize(command)
      @command     = command
      @env         = {}
      @options     = {}
      @side_effect = proc {}
    end

    def with_env(env)
      @env = env

      self
    end

    def with_option(option)
      @options = options

      self
    end

    def and_return(expected_output)
      @expected_output = expected_output
      @exitstatus ||= 0

      self
    end

    def and_exit(exitstatus)
      @exitstatus = exitstatus

      self
    end

    def calls
      @calls ||= []
    end

    def called_with(env, command, options)
      calls << [env, command, options]
    end
  end
end
