require 'open3'

RSpec.describe ShellMock do
  describe "::stub_commmand" do
    before do
      ShellMock.enable
      ShellMock.let_commands_run
    end
    after { ShellMock.disable }

    let!(:stub)      { ShellMock.stub_command('ls') }
    let!(:home_stub) { ShellMock.stub_command("ls $HOME") }

    it 'uses the "closest" stub' do
      `ls $HOME`

      expect(home_stub.runs).to_not eq 0
      expect(stub.runs).to eq 0
    end

    it 'but not too close' do
      `ls /`

      expect(home_stub.runs).to eq 0
      expect(stub.runs).to eq 0
    end
  end

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

    it 'stops Kernel.spawn' do
      expect { Kernel.spawn('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Process.spawn' do
      expect { Process.spawn('ls') }.to raise_error ShellMock::NoStubSpecified
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

    # These high-level callers of spawn need to be tested as well, even though we don't patch them directly.

    it 'stops Open3.popen2' do
      expect { Open3.popen2('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Open3.popen2e' do
      expect { Open3.popen2e('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Open3.popen3' do
      expect { Open3.popen3('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Open3.capture2' do
      expect { Open3.capture2('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Open3.capture2e' do
      expect { Open3.capture2e('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Open3.capture3' do
      expect { Open3.capture3('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Open3.pipeline' do
      expect { Open3.pipeline('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Open3.pipeline_r' do
      expect { Open3.pipeline_r('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Open3.pipeline_w' do
      expect { Open3.pipeline_w('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Open3.pipeline_rw' do
      expect { Open3.pipeline_rw('ls') }.to raise_error ShellMock::NoStubSpecified
    end

    it 'stops Open3.pipeline_start' do
      expect { Open3.pipeline_start('ls') }.to raise_error ShellMock::NoStubSpecified
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

    it 'lets Process.spawn run' do
      expect(Pathname.new('foo')).to_not exist
      expect(Process.wait Process.spawn('touch foo')).to be_a Integer
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

    it "lets Open3.popen2 run" do
      expect(Pathname.new("foo")).to_not exist

      Open3.popen2("touch foo").last.value # wait for termination

      expect(Pathname.new("foo")).to exist
    end

    it "lets Open3.popen2e run" do
      expect(Pathname.new("foo")).to_not exist

      Open3.popen2e("touch foo").last.value # wait for termination

      expect(Pathname.new("foo")).to exist
    end

    it "lets Open3.popen3 run" do
      expect(Pathname.new("foo")).to_not exist

      Open3.popen3("touch foo").last.value # wait for termination

      expect(Pathname.new("foo")).to exist
    end

    it "lets Open3.capture2 run" do
      expect(Pathname.new("foo")).to_not exist
      Open3.capture2("touch foo")
      expect(Pathname.new("foo")).to exist
    end

    it "lets Open3.capture2e run" do
      expect(Pathname.new("foo")).to_not exist
      Open3.capture2e("touch foo")
      expect(Pathname.new("foo")).to exist
    end

    it "lets Open3.capture3 run" do
      expect(Pathname.new("foo")).to_not exist
      Open3.capture3("touch foo")
      expect(Pathname.new("foo")).to exist
    end

    it "lets Open3.pipeline run" do
      expect(Pathname.new("foo")).to_not exist

      status = Open3.pipeline("touch foo").last
      Process.wait(status.pid) unless status.exited?

      expect(Pathname.new("foo")).to exist
    end

    it "lets Open3.pipeline_r run" do
      expect(Pathname.new("foo")).to_not exist

      Open3.pipeline_r("touch foo").last[0].value # wait for termination

      expect(Pathname.new("foo")).to exist
    end

    it "lets Open3.pipeline_w run" do
      expect(Pathname.new("foo")).to_not exist

      Open3.pipeline_w("touch foo").last[0].value # wait for termination

      expect(Pathname.new("foo")).to exist
    end

    it "lets Open3.pipeline_rw run" do
      expect(Pathname.new("foo")).to_not exist

      Open3.pipeline_rw("touch foo").last[0].value # wait for termination

      expect(Pathname.new("foo")).to exist
    end

    it "lets Open3.pipeline_start run" do
      expect(Pathname.new("foo")).to_not exist

      Open3.pipeline_start("touch foo")[0].value # wait for termination

      expect(Pathname.new("foo")).to exist
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

      it 'Process.__un_shell_mocked_spawn has been removed' do
        expect(Process.respond_to?(:__un_shell_mocked_spawn, true)).to eq false
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

    it 'Process.__un_shell_mocked_spawn has been defined' do
      expect(Process.respond_to?(:__un_shell_mocked_spawn, true)).to eq true
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
