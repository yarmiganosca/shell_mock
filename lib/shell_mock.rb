require 'shell_mock/core_ext/module'

require "shell_mock/version"
require 'shell_mock/command_stub'
require 'shell_mock/monkey_patches'
require 'shell_mock/rspec'
require 'shell_mock/stub_registry'

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

  # smell; this is a mistake of a method that will only confuse people
  def self.dont_let_commands_run?
    !let_commands_run?
  end

  def self.enable
    ShellMock.monkey_patches.each(&:enable)

    @enabled = true

    true
  end

  def self.disable
    ShellMock.monkey_patches.each(&:disable)

    StubRegistry.clear

    @enabled          = false
    @let_commands_run = nil

    true
  end

  def self.enabled?
    @enabled
  end

  def self.monkey_patches
    @monkey_patches ||= [
      SpawnMonkeyPatch.new,
      SystemMonkeyPatch.new,
      ExecMonkeyPatch.new,
      BacktickMonkeyPatch.new,
    ]
  end
end
