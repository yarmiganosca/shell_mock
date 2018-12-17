require 'open3'

module ShellMock
  RSpec.describe SpawnMonkeyPatch do
    subject(:patch) { SpawnMonkeyPatch.new }

    context "when enabled" do
      before { patch.enable }
      after do
        patch.disable
        StubRegistry.clear
      end

      context 'and a command is stubbed' do
        let!(:stub)      { ShellMock.stub_command('ls') }
        let!(:home_stub) { ShellMock.stub_command("ls $HOME") }

        it 'intercepts Kernel#spawn' do
          expect(Process.wait spawn('ls', out: "/dev/null")).to be_a Integer

          expect(stub.runs).to_not eq 0
          expect(home_stub.runs).to eq 0
        end

        it 'intercepts Kernel.spawn' do
          expect(Process.wait Kernel.spawn('ls', out: "/dev/null")).to be_a Integer

          expect(stub.runs).to_not eq 0
          expect(home_stub.runs).to eq 0
        end

        it 'intercepts Process.spawn' do
          expect(Process.wait Process.spawn('ls', out: "/dev/null")).to be_a Integer

          expect(stub.runs).to_not eq 0
          expect(home_stub.runs).to eq 0
        end

        context 'and has a 0 exit specified' do
          let(:exitstatus) { 0 }
          let!(:stub) do
            ShellMock.stub_command('ls').to_exit(exitstatus)
          end

          it '"sets" the appropriate exit code for $? with Kernel#spawn' do
            Process.wait spawn('ls', out: "/dev/null")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end

          it '"sets" the appropriate exit code for $? with Kernel.spawn' do
            Process.wait Kernel.spawn('ls', out: "/dev/null")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end

          it '"sets" the appropriate exit code for $? with Process.spawn' do
            Process.wait Process.spawn('ls', out: "/dev/null")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end
        end

        context "and has a non-zero exit specified" do
          let(:exitstatus) { 4 }
          let!(:stub) do
            ShellMock.stub_command('ls').to_exit(exitstatus)
          end

          it '"sets" the appropriate exit code for $? with Kernel#spawn' do
            Process.wait spawn('ls', out: "/dev/null")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end

          it '"sets" the appropriate exit code for $? with Kernel.spawn' do
            Process.wait Kernel.spawn('ls', out: "/dev/null")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end

          it '"sets" the appropriate exit code for $? with Process.spawn' do
            Process.wait Process.spawn('ls', out: "/dev/null")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end
        end
      end

      describe Open3 do
        describe '.capture3' do
          let(:command)    { 'which which' }
          let(:output)     { 'which not found' }
          let(:exitstatus) { 42 }

          before { ShellMock.stub_command(command).to_output(output).to_exit(exitstatus) }

          it "captures the specified output" do
            stdout, stderr, status = Open3.capture3(command)

            expect(stdout.chomp).to eq output
          end

          it 'captures the specified exitstatus' do
            stdout, stderr, status = Open3.capture3(command)

            expect(status.exitstatus).to eq exitstatus
          end
        end

        describe '.popen2e' do
          let(:command)    { 'which which' }
          let(:output)     { 'which not found' }
          let(:exitstatus) { 42 }

          context "when the command is stubbed" do
            before { ShellMock.stub_command(command).to_output(output).to_exit(exitstatus) }

            it "writes the specified output to the stdout pipe" do
              stdin, stdout, waiter = Open3.popen2e(command)

              expect(stdout.read.chomp).to eq output
            end
          end

          context "when the command is not stubbed and command execution is disabled" do
            before { ShellMock.dont_let_commands_run }

            it "raises an error" do
              expect { Open3.popen2e(command) }.to raise_error(
                NoStubSpecified,
                "no stub specified for which which"
              )
            end
          end
        end
      end
    end
  end
end
