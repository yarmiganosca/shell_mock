module ShellMock
  RSpec.describe SystemMonkeyPatch do
    subject(:patch) { described_class.new }

    context "when enabled" do
      before { patch.enable }
      after do
        patch.disable
        StubRegistry.clear
      end

      context 'and a command is stubbed' do
        let!(:stub)      { ShellMock.stub_command('ls') }
        let!(:home_stub) { ShellMock.stub_command("ls $HOME") }

        it 'intercepts Kernel#system' do
          expect(system('ls')).to eq true

          expect(stub.calls).to_not eq 0
          expect(home_stub.calls).to eq 0
        end

        it 'intercepts Kernel.system' do
          expect(Kernel.system('ls')).to eq true

          expect(stub.calls).to_not eq 0
          expect(home_stub.calls).to eq 0
        end

        context 'and has a 0 exit specified' do
          let(:exitstatus) { 0 }
          let!(:stub) do
            ShellMock.stub_command('ls').and_exit(exitstatus)
          end

          it '"sets" the appropriate exit code for $? with Kernel#system' do
            system('ls')

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_been_called
          end

          it '"sets" the appropriate exit code for $? with Kernel.system' do
            Kernel.system('ls')

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_been_called
          end
        end

        context "and has a non-zero exit specified" do
          let(:exitstatus) { 4 }
          let!(:stub) do
            ShellMock.stub_command('ls').and_exit(exitstatus)
          end

          it '"sets" the appropriate exit code for $? with Kernel#system' do
            system('ls')

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_been_called
          end

          it '"sets" the appropriate exit code for $? with Kernel.system' do
            Kernel.system('ls')

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_been_called
          end
        end
      end
    end
  end
end
