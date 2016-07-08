RSpec.describe ShellMock do
  describe '::stub_command' do
    before { ShellMock.enable }
    after { ShellMock.disable }

    context 'a stubbed command' do
      it 'intercepts system' do
        stub = ShellMock.stub_command('ls').and_return("\n")

        expect(system('ls')).to eq true

        expect(stub).to have_been_called
      end

      it 'intercepts backtick' do
        stub = ShellMock.stub_command('ls').and_return("\n")

        expect(`ls`).to eq "\n"

        expect(stub).to have_been_called
      end
    end
  end

  describe '::dont_let_commands_run' do
    after { ShellMock.let_commands_run }

    it 'prevents commands from running' do
      ShellMock.dont_let_commands_run

      expect(ShellMock.let_commands_run?).to be false
      expect(ShellMock.dont_let_commands_run?).to be true
    end
  end

  describe '::let_commands_run' do
    it 'prevents commands from running' do
      ShellMock.let_commands_run

      expect(ShellMock.dont_let_commands_run?).to be false
      expect(ShellMock.let_commands_run?).to be true
    end
  end

  describe '::disable' do
    before { ShellMock.stub_command('ls') }

    it 'clears the stub registry' do
      expect(ShellMock::StubRegistry.command_stubs).to_not be_empty

      ShellMock.disable

      expect(ShellMock::StubRegistry.command_stubs).to be_empty
    end
  end
end
