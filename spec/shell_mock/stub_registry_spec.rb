module ShellMock
  RSpec.describe StubRegistry do
    describe '.stub_matching' do
      after { StubRegistry.clear }

      context "when the stub doesn't specify env vars" do
        let!(:stub) { ShellMock.stub_command('ls') }

        it 'matches invocations with no env vars' do
          expect(StubRegistry.stub_matching(
            {},
            'ls',
            {}
          )).to eq stub
        end

        it 'matches invocations with env vars' do
          expect(StubRegistry.stub_matching(
            {'FOO' => 'bar', 'BAZ' => 'bat'},
            'ls',
            {}
          )).to eq stub
        end
      end

      context 'env vars specified' do
        let!(:stub) { ShellMock.stub_command('ls').with_env('FOO' => 'bar', 'BAZ' => 'bat') }

        it 'matches invocations with the specified env vars' do
          expect(StubRegistry.stub_matching(
            {'FOO' => 'bar', 'BAZ' => 'bat'},
            'ls',
            {}
          )).to eq stub
        end

        it 'matches invocations with more env vars than were specified' do
          expect(StubRegistry.stub_matching(
            {'FOO' => 'bar', 'BAZ' => 'bat', 'WOW' => 'shiny'},
            'ls',
            {}
          )).to eq stub
        end

        it "doesn't match invocations with fewer env vars than were specified" do
          expect(StubRegistry.stub_matching(
            {},
            'ls',
            {}
          )).to be_nil
        end

        it "doesn't match invocations with only some of the specified env vars" do
          expect(StubRegistry.stub_matching(
            {'FOO' => 'bar'},
            'ls',
            {}
          )).to be_nil
        end
      end

      context 'no options specified' do
        pending
      end

      context 'options specified' do
        pending
      end
    end
  end
end
