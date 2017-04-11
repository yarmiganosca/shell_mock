module ShellMock
  RSpec.describe "::stub_commmand" do
    before do
      ShellMock.enable
      ShellMock.let_commands_run
    end
    after { ShellMock.disable }

    let!(:stub)      { ShellMock.stub_command('ls').and_return("\n").and_exit(exit_code) }
    let!(:home_stub) { ShellMock.stub_command("ls $HOME").and_return("\n") }

    let(:exit_code) { 42 }

    it 'intercepts system' do
      expect(system('ls')).to eq (exit_code == 0)

      expect(stub.calls).to_not be_empty
      expect(home_stub.calls).to be_empty
    end

    it 'intercepts backtick' do
      expect(`ls`).to eq "\n"

      expect(stub.calls).to_not be_empty
      expect(home_stub.calls).to be_empty
    end

    context "with a stubbed good exit" do
      it '"sets" the appropriate exit code for $? with system' do
        expect(system('ls')).to eq (exit_code == 0)

        expect($?.exitstatus).to eq stub.exitstatus
      end

      it "sets the appropriate exit code for $? with exec do" do
        child = Process.fork { exec('ls') }
        Process.wait(child)

        expect($?.exitstatus).to eq stub.exitstatus
      end
    end

    context "with a stubbed bad exit" do
      let(:exit_code) { 4 }

      it '"sets" the appropriate exit code for $?' do
        expect(system('ls')).to eq false

        expect($?.exitstatus).to eq exit_code
      end
    end

    it 'uses the "closest" stub' do
      expect(`ls $HOME`).to eq "\n"

      expect(home_stub.calls).to_not be_empty
      expect(stub.calls).to be_empty
    end

    it 'but not too close' do
      expect(`ls /`).to_not eq "\n"

      expect(home_stub.calls).to be_empty
      expect(stub.calls).to be_empty
    end
  end
end
