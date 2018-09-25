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

        it 'intercepts spawn' do
          expect(Process.wait spawn('ls', out: "/dev/null")).to be_a Integer

          expect(stub.calls).to_not eq 0
          expect(home_stub.calls).to eq 0
        end

        it 'intercepts Process.spawn' do
          expect(Process.wait Process.spawn('ls', out: "/dev/null")).to be_a Integer

          expect(stub.calls).to_not eq 0
          expect(home_stub.calls).to eq 0
        end

        context 'and has a 0 exit specified' do
          let(:exitstatus) { 0 }
          let!(:stub) do
            ShellMock.stub_command('ls').and_exit(exitstatus)
          end

          it '"sets" the appropriate exit code for $? with spawn' do
            Process.wait spawn('ls', out: "/dev/null")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_been_called
          end

          it '"sets" the appropriate exit code for $? with Process.spawn' do
            Process.wait Process.spawn('ls', out: "/dev/null")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_been_called
          end
        end

        context "and has a non-zero exit specified" do
          let(:exitstatus) { 4 }
          let!(:stub) do
            ShellMock.stub_command('ls').and_exit(exitstatus)
          end

          it '"sets" the appropriate exit code for $? with spawn' do
            Process.wait spawn('ls', out: "/dev/null")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_been_called
          end

          it '"sets" the appropriate exit code for $? with Process.spawn' do
            Process.wait Process.spawn('ls', out: "/dev/null")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_been_called
          end
        end
      end

      describe Open3 do
        describe '.capture3' do
          let(:command)    { 'which which' }
          let(:output)     { 'which not found' }
          let(:exitstatus) { 42 }

          before { ShellMock.stub_command(command).and_output(output).and_exit(exitstatus) }

          it "captures the specified output" do
            stdout, stderr, status = Open3.capture3(command)

            expect(stdout.chomp).to eq output
          end

          it 'captures the specified exitstatus' do
            stdout, stderr, status = Open3.capture3(command)

            expect(status.exitstatus).to eq exitstatus
          end
        end
      end
    end
  end
end
