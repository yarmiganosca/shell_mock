module ShellMock
  StubRegistry = Object.new

  StubRegistry.instance_exec do
    def register_command_stub(command_stub)
      command_stubs.insert(0, command_stub)

      command_stub
    end

    def stub_matching(env, command, options)
      matching_stubs = command_stubs.select do |command_stub|
        command_stub.env <= env &&
          command.start_with?(command_stub.command) &&
          command_stub.options <= options
      end

      matching_stubs.max_by { |command_stub| command_stub.command.size }
    end

    def command_stubs
      @command_stubs ||= []
    end

    def clear
      @command_stubs = []
    end
  end
end
