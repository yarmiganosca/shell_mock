require 'shell_mock/rspec'

module ShellMock
  RSpec.describe "::stub_commmand" do
    before do
      ShellMock.enable
      ShellMock.let_commands_run
    end
    after { ShellMock.disable }

    let!(:stub)      { ShellMock.stub_command('ls').and_output("\n").and_exit(exitstatus) }
    let!(:home_stub) { ShellMock.stub_command("ls $HOME").and_return("\n") }

    let(:exitstatus) { 0 }

    it 'intercepts system' do
      expect(system('ls')).to eq true

      expect(stub.calls).to_not eq 0
      expect(home_stub.calls).to eq 0
    end

    context "with a stubbed good exit" do
      it '"sets" the appropriate exit code for $? with system' do
        expect(system('ls')).to eq true

        expect($?.exitstatus).to eq exitstatus
        expect(stub).to have_been_called
      end

      it "sets the appropriate exit code for $? with exec do" do
        Process.wait(fork { exec('ls') })

        expect($?.exitstatus).to eq exitstatus
        expect(stub).to have_been_called
      end
    end

    context "with a stubbed bad exit" do
      let(:exitstatus) { 4 }

      it '"sets" the appropriate exit code for $? with system' do
        expect(system('ls')).to eq false

        expect($?.exitstatus).to eq exitstatus
        expect(stub).to have_been_called
      end

      it "sets the appropriate exit code for $? with exec do" do
        Process.wait(fork { exec('ls') })

        expect($?.exitstatus).to eq exitstatus
        expect(stub).to have_been_called
      end
    end

    it 'uses the "closest" stub' do
      expect(`ls $HOME`.chomp).to eq "\n"

      expect(home_stub.calls).to_not eq 0
      expect(stub.calls).to eq 0
    end

    it 'but not too close' do
      expect(`ls /`.chomp).to_not eq "\n"

      expect(home_stub.calls).to eq 0
      expect(stub.calls).to eq 0
    end
  end
end
