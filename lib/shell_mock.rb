require "shell_mock/version"
require 'shell_mock/stub_registry'
require 'shell_mock/command_stub'
require 'shell_mock/monkey_patches'
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
      patch.enable_for(Kernel.eigenclass) unless Kernel.respond_to?(patch.alias_for_original, true)
      patch.enable_for(Kernel)            unless Object.new.respond_to?(patch.alias_for_original, true)
    end
  end

  def self.disable
    ShellMock.monkey_patches.each do |patch|
      patch.disable_for(Kernel.eigenclass) if Kernel.respond_to?(patch.alias_for_original, true)
      patch.disable_for(Kernel)            if Object.new.respond_to?(patch.alias_for_original, true)
    end

    StubRegistry.clear
  end

  def self.monkey_patches
    [
      SpawnMonkeyPatch,
      SystemMonkeyPatch,
      ExecMonkeyPatch,
      BacktickMonkeyPatch
    ]
  end
end
