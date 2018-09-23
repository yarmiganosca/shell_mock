require 'open3'

module ShellMock
  RSpec.describe SpawnMonkeyPatch do
    context "when enabled" do
      describe Open3 do
        describe '.capture3' do
          let(:command)    { 'which which' }
          let(:output)     { 'which not found' }
          let(:exitstatus) { 42 }

          before do
            ShellMock.stub_command(command).and_output(output).and_exit(exitstatus)
            ShellMock.enable
          end

          after { ShellMock.disable }

          it "captures the specified output" do
            stdout, stderr, status = Open3.capture3(command)

            expect(stdout.chomp).to eq output
          end

          it 'captures the specified exitstatus' do
            stdout, stderr, status = Open3.capture3(command)

            expect(status.exitstatus).to eq exitstatus
          end
        end
      end
    end
  end
end
