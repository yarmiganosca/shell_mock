module ShellMock
  RSpec.describe "::stub_commmand" do
    before { ShellMock.enable }
    after { ShellMock.disable }

    let!(:stub) { ShellMock.stub_command('ls').and_return("\n") }
    let!(:home_stub) { ShellMock.stub_command("ls $HOME").and_return("\n") }

    it 'intercepts system' do
      expect(system('ls')).to eq true

      expect(stub.calls).to_not be_empty
    end

    it 'intercepts backtick' do
      expect(`ls`).to eq "\n"

      expect(stub.calls).to_not be_empty
    end

    it 'uses the "closest" stub' do
      expect(`ls $HOME`).to eq "\n"

      expect(home_stub.calls).to_not be_empty
      expect(stub.calls).to be_empty
    end
  end
end
