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

    it 'stops Kernel#spawn' do
      expect { spawn('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Kernel.spaw' do
      expect { Kernel.spawn('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Kernel#system' do
      expect { system('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Kernel#`' do
      expect { `ls` }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Kernel.system' do
      expect { Kernel.system('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Kernel.`' do
      expect { Kernel.send("`", "ls") }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Kernel#exec' do
      expect { exec('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Kernel.exec' do
      expect { Kernel.exec('ls') }.to raise_error ShellMock::NoStubSpecified
    end
  end

  shared_examples_for "commands are allowed to run" do
    it 'lets Kernel#spawn run' do
      expect(Pathname.new('foo')).to_not exist
      expect(Process.wait spawn('touch foo')).to be_a Integer
      expect(Pathname.new('foo')).to exist
    end

    it 'lets Kernel.spawn run' do
      expect(Pathname.new('foo')).to_not exist
      expect(Process.wait Kernel.spawn('touch foo')).to be_a Integer
      expect(Pathname.new('foo')).to exist
    end

    it 'lets Kernel#system run' do
      expect(Pathname.new('foo')).to_not exist
      expect(system('touch foo')).to eq true
      expect(Pathname.new('foo')).to exist
    end

    it 'lets Kernel.system run' do
      expect(Pathname.new('foo')).to_not exist
      expect(Kernel.system('touch foo')).to eq true
      expect(Pathname.new('foo')).to exist
    end

    it 'lets Kernel#` run' do
      expect(Pathname.new('foo')).to_not exist
      `touch foo`
      expect(Pathname.new('foo')).to exist
    end

    it 'lets Kernel.` run' do
      expect(Pathname.new('foo')).to_not exist
      Kernel.send("`", "touch foo")
      expect(Pathname.new('foo')).to exist
    end

    it 'lets Kernel#exec run' do
      expect(Pathname.new('foo')).to_not exist

      # we need to fork because exec replaces the calling process with the subprocess
      child = Process.fork { exec('touch foo') }
      Process.wait(child)

      expect(Pathname.new('foo')).to exist
    end

    it 'lets Kernel.exec run' do
      expect(Pathname.new('foo')).to_not exist

      # we need to fork because exec replaces the calling process with the subprocess
      child = Process.fork { Kernel.exec('touch foo') }
      Process.wait(child)

      expect(Pathname.new('foo')).to exist
    end
  end

  describe '::let_commands_run' do
    before { ShellMock.let_commands_run }
    after  { File.delete('foo') if File.exist?('foo') }

    it 'indicates that it lets commands run' do
      expect(ShellMock.dont_let_commands_run?).to be false
      expect(ShellMock.let_commands_run?).to be true
    end

    it_behaves_like "commands are allowed to run"
  end

  describe '::disable' do
    after do
      ShellMock.disable
      File.delete('foo') if File.exist?('foo')
    end

    it 'clears the stub registry' do
      ShellMock.enable
      ShellMock.stub_command('touch foo')

      expect(ShellMock::StubRegistry.command_stubs).to_not be_empty

      ShellMock.disable

      expect(ShellMock::StubRegistry.command_stubs).to be_empty
    end

    it_behaves_like "commands are allowed to run" do
      before { ShellMock.disable }
    end

    describe 'the aliased' do
      before do
        ShellMock.enable
        ShellMock.disable
      end

      it 'Kernel#__un_shell_mocked_spawn has been removed' do
        expect(Object.new.respond_to?(:__un_shell_mocked_spawn, true)).to eq false
      end

      it 'Kernel.__un_shell_mocked_spawn has been removed' do
        expect(Kernel.respond_to?(:__un_shell_mocked_spawn, true)).to eq false
      end

      it 'Kernel#__un_shell_mocked_system has been removed' do
        expect(Object.new.respond_to?(:__un_shell_mocked_system, true)).to eq false
      end

      it 'Kernel.__un_shell_mocked_system has been removed' do
        expect(Kernel.respond_to?(:__un_shell_mocked_system, true)).to eq false
      end

      it 'Kernel#__un_shell_mocked_backtick has been removed' do
        expect(Object.new.respond_to?(:__un_shell_mocked_backtick, true)).to eq false
      end

      it 'Kernel.__un_shell_mocked_backtick has been removed' do
        expect(Kernel.respond_to?(:__un_shell_mocked_backtick, true)).to eq false
      end

      it 'Kernel#__un_shell_mocked_exec has been removed' do
        expect(Object.new.respond_to?(:__un_shell_mocked_exec, true)).to eq false
      end

      it 'Kernel.__un_shell_mocked_exec has been removed' do
        expect(Kernel.respond_to?(:__un_shell_mocked_exec, true)).to eq false
      end
    end
  end

  describe '::enable' do
    before { ShellMock.enable }
    after  { ShellMock.disable }

    it 'Kernel#__un_shell_mocked_spawn has been defined' do
      expect(Object.new.respond_to?(:__un_shell_mocked_spawn, true)).to eq true
    end

    it 'Kernel.__un_shell_mocked_spawn has been defined' do
      expect(Kernel.respond_to?(:__un_shell_mocked_spawn, true)).to eq true
    end

    it 'Kernel#__un_shell_mocked_system has been defined' do
      expect(Object.new.respond_to?(:__un_shell_mocked_system, true)).to eq true
    end

    it 'Kernel.__un_shell_mocked_system has been defined' do
      expect(Kernel.respond_to?(:__un_shell_mocked_system, true)).to eq true
    end

    it 'Kernel#__un_shell_mocked_backtick has been defined' do
      expect(Object.new.respond_to?(:__un_shell_mocked_backtick, true)).to eq true
    end

    it 'Kernel.__un_shell_mocked_backtick has been defined' do
      expect(Kernel.respond_to?(:__un_shell_mocked_backtick, true)).to eq true
    end

    it 'Kernel#__un_shell_mocked_exec has been defined' do
      expect(Object.new.respond_to?(:__un_shell_mocked_exec, true)).to eq true
    end

    it 'Kernel.__un_shell_mocked_exec has been defined' do
      expect(Kernel.respond_to?(:__un_shell_mocked_exec, true)).to eq true
    end
  end
end
