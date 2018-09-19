require 'shell_mock/monkey_patch'
require 'shell_mock/stub_registry'
require 'shell_mock/no_stub_specified'

module ShellMock
  class ExecMonkeyPatch < MonkeyPatch
    def method_name
      :exec
    end

    def override(env, command = nil, **options)
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
  end
end
