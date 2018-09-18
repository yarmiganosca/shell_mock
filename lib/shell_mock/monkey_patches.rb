require 'shell_mock/monkey_patch'

module ShellMock
  SystemMonkeyPatch = MonkeyPatch.new(:system) do |env, command = nil, **options|
    env, command = {}, env if command.nil?

    # other arg manipulation

    stub = ShellMock::StubRegistry.stub_matching(env, command, options)

    if stub
      stub.side_effect.call
      stub.called_with(env, command, options)
      __un_shell_mocked_backtick("exit #{stub.exitstatus}")

      return stub.exitstatus == 0
    else
      if ShellMock.let_commands_run?
        __un_shell_mocked_system(env, command, **options)
      else
        raise ShellMock::NoStubSpecified.new(env, command, options)
      end
    end
  end

  # This feels very boilerplatey because Kernel::system and Kernel::exec
  # have very similar if not identical method signatures. I'm not sure
  # whether extracting the commonalities would be worth it or would just
  # confuse.
  ExecMonkeyPatch = MonkeyPatch.new(:exec) do |env, command = nil, **options|
    env, command = {}, env if command.nil?

    # other arg manipulation

    stub = ShellMock::StubRegistry.stub_matching(env, command, options)

    if stub
      stub.side_effect.call
      stub.called_with(env, command, options)

      exit stub.exitstatus
    else
      if ShellMock.let_commands_run?
        __un_shell_mocked_exec(env, command, **options)
      else
        raise ShellMock::NoStubSpecified.new(env, command, options)
      end
    end
  end

  BacktickMonkeyPatch = MonkeyPatch.new('`', :backtick) do |command|
    stub = ShellMock::StubRegistry.stub_matching({}, command, {})

    if stub
      stub.side_effect.call
      __un_shell_mocked_backtick("exit #{stub.exitstatus}")
      stub.called_with({}, command, {})

      return stub.expected_output
    else
      if ShellMock.let_commands_run?
        __un_shell_mocked_backtick(command)
      else
        raise ShellMock::NoStubSpecified.new({}, command, {})
      end
    end
  end
end
