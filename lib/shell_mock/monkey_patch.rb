require 'shell_mock/no_stub_specified'

module ShellMock
  class MonkeyPatch
    attr_reader :original, :alias_for_original

    def initialize(original_name, interpolable_name = original_name, &block)
      @original           = original_name
      @alias_for_original = "__un_shell_mocked_#{interpolable_name}"
      @replacement        = "__shell_mocked_#{interpolable_name}"
      @block              = block
    end

    def to_proc
      @block.to_proc
    end

    def enable_for(class_or_module)
      class_or_module.send(:alias_method, alias_for_original, original)

      begin
        # so we don't have to see method redefinition warnings
        class_or_module.send(:remove_method, original)
      rescue NameError
      end

      class_or_module.send(:define_method, original, &to_proc)
    end

    def disable_for(class_or_module)
      begin
        # so we don't have to see method redefinition warnings
        class_or_module.send(:remove_method, original)
      rescue NameError
      end

      class_or_module.send(:alias_method, original, alias_for_original)

      begin
        class_or_module.send(:remove_method, alias_for_original)
      rescue NameError
      end
    end
  end

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
  # whether extracting the commonalities would be worth it or just
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
