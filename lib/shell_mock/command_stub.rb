require 'shell_mock/call_verifier'
require 'shell_mock/stub_registry'

module ShellMock
  class CommandStub
    attr_reader :command, :expected_output, :exitstatus, :env, :options, :side_effect, :writer

    def initialize(command)
      @command     = command
      @env         = {}
      @options     = {}
      @side_effect = proc {}
      @exitstatus  = 0

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

    def and_output(expected_output)
      @expected_output = expected_output

      self
    end

    def and_return(expected_output)
      self.
        and_output(expected_output).
        and_exit(0)
    end

    def and_exit(exitstatus)
      @exitstatus = exitstatus

      self
    end

    def calls
      @calls ||= []

      marshaled_signatures.each do |marshaled_signature|
        @calls << Marshal.load(marshaled_signature)
      end

      @calls
    end

    def called_with(env, command, options)
      signature = Marshal.dump([env, command, options])

      writer.puts(signature)
    end

    private

    attr_reader :reader

    def marshaled_signatures
      messages = ""

      loop do
        begin
          messages += reader.read_nonblock(1)
        rescue IO::WaitReadable
          break
        end
      end

      messages.split("\n")
    end
  end
end
