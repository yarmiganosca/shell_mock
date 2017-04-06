RSpec.describe ShellMock do
  describe '::dont_let_commands_run' do
    before do
      ShellMock.enable
      ShellMock.dont_let_commands_run
    end

    after do
      ShellMock.let_commands_run
      ShellMock.disable
    end

    it 'indicates that it prevents commands from running' do
      expect(ShellMock.let_commands_run?).to be false
      expect(ShellMock.dont_let_commands_run?).to be true
    end

    it 'stops system' do
      expect { system('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops exec' do
      expect { exec('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops backtick' do
      expect { `ls` }.to raise_error ShellMock::NoStubSpecified
    end
  end

  describe '::let_commands_run' do
    before { ShellMock.let_commands_run }
    after  { File.delete('foo') if File.exist?('foo') }

    it 'indicates that it lets commands run' do
      expect(ShellMock.dont_let_commands_run?).to be false
      expect(ShellMock.let_commands_run?).to be true
    end

    it 'lets system run' do
      expect(system('touch foo')).to eq true
      expect(Pathname.new('foo')).to exist
    end

    it 'lets backtick run' do
      `touch foo`
      expect(Pathname.new('foo')).to exist
    end

    it 'lets exec run' do
      # we need to fork because exec replaces the calling process with the subprocess
      child = Process.fork { exec('touch foo') }
      Process.wait(child)

      expect(Pathname.new('foo')).to exist
    end
  end

  describe '::disable' do
    before do
      ShellMock.enable
      ShellMock.stub_command('ls')
    end

    after { ShellMock.disable }

    it 'clears the stub registry' do
      expect(ShellMock::StubRegistry.command_stubs).to_not be_empty

      ShellMock.disable

      expect(ShellMock::StubRegistry.command_stubs).to be_empty
    end
  end
end
