require 'shell_mock/no_stub_specified'

module Kernel
  def __shell_mocked_system(env, command = nil, **options)
    env, command = {}, env if command.nil?

    # other arg manipulation

    stub = ShellMock::StubRegistry.stub_matching(env, command, options)

    if stub
      stub.side_effect.call
      `exit #{stub.exitstatus}`
      stub.called_with(env, command, options)

      return stub.exitstatus == 0
    else
      if ShellMock.let_commands_run?
        __un_shell_mocked_system(env, command, **options)
      else
        raise ShellMock::NoStubSpecified.new(env, command, options)
      end
    end
  end

  def __shell_mocked_backtick(command)
    stub = ShellMock::StubRegistry.stub_matching({}, command, {})

    if stub
      stub.side_effect.call
      `exit #{stub.exitstatus}`
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
