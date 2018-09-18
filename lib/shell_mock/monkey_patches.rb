require 'shell_mock/monkey_patch'
require 'shell_mock/stub_registry'
require 'shell_mock/no_stub_specified'

module ShellMock
  SpawnMonkeyPatch = MonkeyPatch.new(:spawn) do |env, command = nil, **options|
    env, command = {}, env if command.nil?

    # other arg manipulation can go here if necessary

    stub = StubRegistry.stub_matching(env, command, options)

    if stub
      stub.called_with(env, command, options)

      stub.side_effect.call

      __un_shell_mocked_spawn("exit #{stub.exitstatus}")
    else
      if ShellMock.let_commands_run?
        __un_shell_mocked_spawn(env, command, **options)
      else
        raise NoStubSpecified.new(env, command, options)
      end
    end
  end

  SystemMonkeyPatch = MonkeyPatch.new(:system) do |env, command = nil, **options|
    env, command = {}, env if command.nil?

    # other arg manipulation can go here if necessary

    stub = StubRegistry.stub_matching(env, command, options)

    if stub
      stub.called_with(env, command, options)

      stub.side_effect.call
      __un_shell_mocked_backtick("exit #{stub.exitstatus}")

      return stub.exitstatus == 0
    else
      if ShellMock.let_commands_run?
        __un_shell_mocked_system(env, command, **options)
      else
        raise NoStubSpecified.new(env, command, options)
      end
    end
  end

  # This feels very boilerplatey because Kernel::system and Kernel::exec
  # have very similar if not identical method signatures. I'm not sure
  # whether extracting the commonalities would be worth it or would just
  # confuse.
  ExecMonkeyPatch = MonkeyPatch.new(:exec) do |env, command = nil, **options|
    env, command = {}, env if command.nil?

    # other arg manipulation can go here if necessary

    stub = StubRegistry.stub_matching(env, command, options)

    if stub
      stub.called_with(env, command, options)

      stub.side_effect.call

      exit stub.exitstatus
    else
      if ShellMock.let_commands_run?
        __un_shell_mocked_exec(env, command, **options)
      else
        raise NoStubSpecified.new(env, command, options)
      end
    end
  end

  BacktickMonkeyPatch = MonkeyPatch.new('`', :backtick) do |command|
    stub = StubRegistry.stub_matching({}, command, {})

    if stub
      stub.called_with({}, command, {})

      stub.side_effect.call
      __un_shell_mocked_backtick("exit #{stub.exitstatus}")

      return stub.expected_output
    else
      if ShellMock.let_commands_run?
        __un_shell_mocked_backtick(command)
      else
        raise NoStubSpecified.new({}, command, {})
      end
    end
  end
end
