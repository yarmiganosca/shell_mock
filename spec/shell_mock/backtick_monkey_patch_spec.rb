module ShellMock
  RSpec.describe BacktickMonkeyPatch do
    subject(:patch) { described_class.new }

    context "when enabled" do
      before { patch.enable }
      after do
        patch.disable
        StubRegistry.clear
      end

      context 'and a command is stubbed' do
        let!(:stub)      { ShellMock.stub_command('ls').to_return("\n") }
        let!(:home_stub) { ShellMock.stub_command("ls $HOME").to_return("\n") }

        it 'intercepts Kernel#`' do
          expect(`ls`.chomp).to eq "\n"

          expect(stub.runs).to_not eq 0
          expect(home_stub.runs).to eq 0
        end

        it 'intercepts Kernel.`' do
          expect(Kernel.send("`", "ls").chomp).to eq "\n"

          expect(stub.runs).to_not eq 0
          expect(home_stub.runs).to eq 0
        end

        it 'intercepts %x literals' do
          expect(%x{ls}.chomp).to eq "\n"

          expect(stub.runs).to_not eq 0
          expect(home_stub.runs).to eq 0
        end

        context 'and has a 0 exit specified' do
          let(:exitstatus) { 0 }
          let!(:stub) do
            ShellMock.stub_command('ls').to_exit(exitstatus)
          end

          it '"sets" the appropriate exit code for $? with Kernel#`' do
            `ls`

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end

          it '"sets" the appropriate exit code for $? with Kernel.`' do
            Kernel.send("`", "ls")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end

          it '"sets" the appropriate exit code for $? with %x literals' do
            %x{ls}

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end
        end

        context "and has a non-zero exit specified" do
          let(:exitstatus) { 4 }
          let!(:stub) do
            ShellMock.stub_command('ls').to_exit(exitstatus)
          end

          it '"sets" the appropriate exit code for $? with Kernel#`' do
            `ls`

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end

          it '"sets" the appropriate exit code for $? with Kernel.`' do
            Kernel.send("`", "ls")

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end

          it '"sets" the appropriate exit code for $? with %x literals' do
            %x{ls}

            expect($?.exitstatus).to eq exitstatus
            expect(stub).to have_run
          end
        end
      end
    end
  end
end
