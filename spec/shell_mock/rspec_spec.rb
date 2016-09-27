require 'shell_mock/rspec'

RSpec.describe ShellMock do
  before { ShellMock.enable }
  after { ShellMock.disable }

  let!(:stub) { ShellMock.stub_command('ls').and_return("\n") }

  context 'being called once' do
    before { system('ls') }

    it 'is matched when expected once' do
      expect(stub).to have_been_called.once
    end

    it 'is not matched when not expected' do
      expect(stub).to_not have_been_called.never
    end
  end

  context 'being called twice' do
    before { system('ls'); `ls` }

    it 'is matched when expected twice' do
      expect(stub).to have_been_called.times(2)
    end

    it 'is matched when expected more times than once' do
      expect(stub).to have_been_called.more_than(1)
    end

    it 'is matched when expected fewer times than thrice' do
      expect(stub).to have_been_called.fewer_than(3)
      expect(stub).to have_been_called.less_than(3)
    end

    it 'is not matched when not expected' do
      expect(stub).to_not have_been_called.never
    end
  end
end
