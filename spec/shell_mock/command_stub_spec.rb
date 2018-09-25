require 'shell_mock/rspec'

module ShellMock
  RSpec.describe "::stub_commmand" do
    before do
      ShellMock.enable
      ShellMock.let_commands_run
    end
    after { ShellMock.disable }

    let!(:stub)      { ShellMock.stub_command('ls') }
    let!(:home_stub) { ShellMock.stub_command("ls $HOME") }

    it 'uses the "closest" stub' do
      `ls $HOME`

      expect(home_stub.calls).to_not eq 0
      expect(stub.calls).to eq 0
    end

    it 'but not too close' do
      `ls /`

      expect(home_stub.calls).to eq 0
      expect(stub.calls).to eq 0
    end
  end
end
