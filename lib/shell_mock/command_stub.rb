require 'shell_mock/stub_registry'

module ShellMock
  class CommandStub
    attr_reader :command, :output, :exitstatus, :env, :options, :side_effect

    def initialize(command)
      @command     = command
      @env         = {}
      @options     = {}
      @side_effect = proc {}
      @exitstatus  = 0
      @output      = nil

      @reader, @writer = IO.pipe
    end

    def with_env(env)
      @env = env

      self
    end

    def with_options(options)
      @options = options

      self
    end

    def and_output(output)
      @output = output

      self
    end

    def and_return(output)
      self.
        and_output(output).
        and_exit(0)
    end

    def and_exit(exitstatus)
      @exitstatus = exitstatus

      self
    end

    def and_succeed
      and_exit(0)
    end

    def and_fail
      and_exit(1)
    end

    def runs
      @runs ||= 0

      loop do
        begin
          reader.read_nonblock(1)
          @runs += 1
        rescue IO::WaitReadable
          break
        end
      end

      @runs
    end

    def ran
      writer.write("R")
    end

    def to_oneliner
      if output
        "echo '#{output}' && exit #{exitstatus}"
      else
        "exit #{exitstatus}"
      end
    end

    private

    attr_reader :reader, :writer
  end
end
