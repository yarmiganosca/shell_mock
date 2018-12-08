module ShellMock
  RSpec.describe CommandStub do
    subject(:command_stub) { described_class.new('ls') }

    describe '#with_env' do
      it 'sets env vars needed to match against this command stub' do
        expect(command_stub.with_env({'X' => 'Y'}).env).to include({'X' => 'Y'})
      end
    end

    describe '#with_options' do
      it 'sets options needed to match against this command stub' do
        expect(command_stub.with_options({err: :out}).options).to include({err: :out})
      end
    end

    describe '#to_output' do
      it "specifies the output the invocation will generate instead of it's 'normal' output" do
        expect(command_stub.to_output("42\n").output).to eq "42\n"
      end
    end

    describe '#to_exit' do
      it "specifies the status the invocation will exit with instead of it's 'normal' exit status" do
        expect(command_stub.to_exit(42).exitstatus).to eq 42
      end
    end

    describe '#to_return' do
      it "specifies the output the invocation will generate instead of it's 'normal' output" do
        expect(command_stub.to_return("42\n").output).to eq "42\n"
      end

      it "specifies that the invocation will exit with status 0" do
        expect(command_stub.to_return("42\n").exitstatus).to eq 0
      end
    end

    describe '#to_succeed' do
      it "specifies that the invocation will exit 0" do
        expect(command_stub.to_succeed.exitstatus).to eq 0
      end
    end

    describe '#to_fail' do
      it "specifies that the status the invocation will exit 1" do
        expect(command_stub.to_fail.exitstatus).to eq 1
      end
    end

    describe '#to_oneliner' do
      context 'when output is set' do
        before { command_stub.to_output("42\n") }

        it 'echoes that output' do
          expect(command_stub.to_oneliner).to include "echo '42\n'"
        end
      end

      context 'when the exitstatus is set' do
        before { command_stub.to_exit(42) }

        it 'exits with that status' do
          expect(command_stub.to_oneliner).to include "exit 42"
        end
      end

      context 'when the output and exitstatus are set' do
        before { command_stub.to_output("42\n").to_exit(42) }

        it 'echoes that output' do
          expect(command_stub.to_oneliner).to include "echo '42\n'"
        end

        it 'exits with that status' do
          expect(command_stub.to_oneliner).to include "exit 42"
        end
      end
    end
  end
end
