require "shell_mock/version"
require 'shell_mock/stub_registry'
require 'shell_mock/command_stub'
require 'shell_mock/monkey_patch'
require 'shell_mock/core_ext/module'

module ShellMock
  def self.stub_command(command)
    command_stub = CommandStub.new(command)

    StubRegistry.register_command_stub(command_stub)
  end

  def self.let_commands_run
    @let_commands_run = true
  end

  def self.dont_let_commands_run
    @let_commands_run = false
  end

  def self.let_commands_run?
    @let_commands_run = true if @let_commands_run.nil?
    @let_commands_run
  end

  def self.dont_let_commands_run?
    !let_commands_run?
  end

  def self.enable
    ShellMock.monkey_patches.each do |patch|
      Kernel.send(:alias_method, patch.alias_for_original, patch.original)

      begin
        Kernel.send(:remove_method, patch.original) # for warnings
      rescue NameError
      end

      Kernel.send(:define_method, patch.original, &patch.to_proc)

      Kernel.eigenclass_exec do
        send(:alias_method, patch.alias_for_original, patch.original)

        begin
          send(:remove_method, patch.original) # for warnings
        rescue NameError
        end

        send(:define_method, patch.original, &patch.to_proc)
      end
    end
  end

  def self.disable
    ShellMock.monkey_patches.each do |patch|
      if Object.new.respond_to?(patch.alias_for_original, true)
        begin
          Kernel.send(:remove_method, patch.original) # for warnings
        rescue NameError
        end

        Kernel.send(:alias_method, patch.original, patch.alias_for_original)

        begin
          Kernel.send(:remove_method, patch.alias_for_original)
        rescue NameError
        end
      end

      if Kernel.respond_to?(patch.alias_for_original, true)
        Kernel.eigenclass_exec do
          begin
            send(:remove_method, patch.original) # for warnings
          rescue NameError
          end

          send(:alias_method, patch.original, patch.alias_for_original)

          begin
            send(:remove_method, patch.alias_for_original)
          rescue NameError
          end
        end
      end
    end

    StubRegistry.clear
  end

  def self.monkey_patches
    [SystemMonkeyPatch, ExecMonkeyPatch, BacktickMonkeyPatch]
  end
end
