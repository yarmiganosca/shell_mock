RSpec.describe '::SpawnArguments' do
  context 'when command is of the form: commandline' do
    context '(commandline)' do
      it '-> [{}, commandline, {}]' do
        expect(SpawnArguments(
          'commandline'
        )).to eq(
          [{}, 'commandline', {}]
        )
      end
    end

    context '(commandline, options)' do
      it "-> [{}, commandline, options]" do
        expect(SpawnArguments(
          'commandline', [:out, :err] => "/dev/null"
        )).to eq(
          [{}, 'commandline', {[:out, :err] => "/dev/null"}]
        )
      end
    end

    context '(env, commandline)' do
      it "-> [env, commandline, {}]" do
        expect(SpawnArguments(
          {'FOO' => 'BAR'}, 'commandline'
        )).to eq(
          [{'FOO' => 'BAR'}, 'commandline', {}]
        )
      end
    end

    context '(env, commandline, options)' do
      it '-> [env, commandline, options]' do
        expect(SpawnArguments(
          {'FOO' => 'BAR'}, 'commandline', [:out, :err] => "/dev/null"
        )).to eq(
          [{'FOO' => 'BAR'}, 'commandline', {[:out, :err] => "/dev/null"}]
        )
      end
    end
  end

  context 'when command is of the form: command, arg1, ...' do
    context '(command, arg1, arg2)' do
      it '-> [{}, [command, arg1, arg2], {}]' do
        expect(SpawnArguments(
          'command', 'arg1', 'arg2'
        )).to eq(
          [{}, ['command', 'arg1', 'arg2'], {}]
        )
      end
    end

    context '(command, arg1, arg2, options)' do
      it "-> [{}, [command, arg1, arg2], options]" do
        expect(SpawnArguments(
          'command', 'arg1', 'arg2', [:out, :err] => "/dev/null"
        )).to eq(
          [{}, ['command', 'arg1', 'arg2'], {[:out, :err] => "/dev/null"}]
        )
      end
    end

    context '(env, command, arg1, arg2)' do
      it "-> [env, [command, arg1, arg2], {}]" do
        expect(SpawnArguments(
          {'FOO' => 'BAR'}, 'command', 'arg1', 'arg2'
        )).to eq(
          [{'FOO' => 'BAR'}, ['command', 'arg1', 'arg2'], {}]
        )
      end
    end

    context '(env, command, arg1, arg2, options)' do
      it '-> [env, [command, arg1, arg2], options]' do
        expect(SpawnArguments(
          {'FOO' => 'BAR'}, 'command', 'arg1', 'arg2', [:out, :err] => "/dev/null"
        )).to eq(
          [{'FOO' => 'BAR'}, ['command', 'arg1', 'arg2'], {[:out, :err] => "/dev/null"}]
        )
      end
    end
  end

  context 'when command is of the form: [command, argv0]' do
    context '([command, argv0])' do
      it '-> [{}, [[command, argv0]], {}]' do
        expect(SpawnArguments(
          ['command', 'argv0']
        )).to eq(
          [{}, [['command', 'argv0']], {}]
        )
      end
    end

    context '([command, argv0], options)' do
      it "-> [{}, [[command, argv0]], options]" do
        expect(SpawnArguments(
          ['command', 'argv0'], [:out, :err] => "/dev/null"
        )).to eq(
          [{}, [['command', 'argv0']], {[:out, :err] => "/dev/null"}]
        )
      end
    end

    context '(env, [command, argv0])' do
      it "-> [env, [[command, argv0]], {}]" do
        expect(SpawnArguments(
          {'FOO' => 'BAR'}, ['command', 'argv0']
        )).to eq(
          [{'FOO' => 'BAR'}, [['command', 'argv0']], {}]
        )
      end
    end    

    context '(env, [command, argv0], options)' do
      it '-> [env, [[command, argv0]], options]' do
        expect(SpawnArguments(
          {'FOO' => 'BAR'}, ['command', 'argv0'], [:out, :err] => "/dev/null"
        )).to eq(
          [{'FOO' => 'BAR'}, [['command', 'argv0']], {[:out, :err] => "/dev/null"}]
        )
      end
    end
  end

  context 'when command is of the form: [command, argv0], arg1, ...' do
    context '([command, argv0], arg1, arg2)' do
      it '-> [{}, [[command, argv0], arg1, arg2], {}]' do
        expect(SpawnArguments(
          ['command', 'argv0'], 'arg1', 'arg2'
        )).to eq(
          [{}, [['command', 'argv0'], 'arg1', 'arg2'], {}]
        )
      end
    end

    context 'whne passed a command and options ([command, argv0], options)' do
      it "-> [{}, [[command, argv0], arg1, arg2], options]" do
        expect(SpawnArguments(
          ['command', 'argv0'], 'arg1', 'arg2', [:out, :err] => "/dev/null"
        )).to eq(
          [{}, [['command', 'argv0'], 'arg1', 'arg2'], {[:out, :err] => "/dev/null"}]
        )
      end
    end

    context '(env, [command, argv0], arg1, arg2)' do
      it "-> [env, [[commmand, argv0], arg1, arg2], {}]" do
        expect(SpawnArguments(
          {'FOO' => 'BAR'}, ['command', 'argv0'], 'arg1', 'arg2'
        )).to eq(
          [{'FOO' => 'BAR'}, [['command', 'argv0'], 'arg1', 'arg2'], {}]
        )
      end
    end

    context '(env, [command, argv0], arg1, arg2, options)' do
      it '-> [env, [[command, argv0], arg1, arg2], options]' do
        expect(SpawnArguments(
          {'FOO' => 'BAR'}, ['command', 'argv0'], 'arg1', 'arg2', [:out, :err] => "/dev/null"
        )).to eq(
          [{'FOO' => 'BAR'}, [['command', 'argv0'], 'arg1', 'arg2'], {[:out, :err] => "/dev/null"}]
        )
      end
    end
  end

  context 'when no command is provided' do
    context '()' do
      it 'raises an ArgumentError' do
        expect { SpawnArguments() }.to raise_error(ArgumentError)
      end
    end

    context '(env)' do
      it 'raises an ArgumentError' do
        expect {
          SpawnArguments({'FOO' => 'BAR'})
        }.to raise_error(ArgumentError)
      end
    end

    context '(env, options)' do
      it 'raises an ArgumentError' do
        expect {
          SpawnArguments({'FOO' => 'BAR'}, [:out, :err] => "/dev/null")
        }.to raise_error(ArgumentError)
      end
    end

    context '(options)' do
      it 'raises an ArgumentError' do
        expect {
          SpawnArguments([:out, :err] => "/dev/null")
        }.to raise_error(ArgumentError)
      end
    end
  end

  context "when the command and the env vars are out of order" do
    context '(command, env, arg1, arg2)' do
      it 'raises an ArgumentError' do
        expect {
          SpawnArguments('command', {'FOO' => 'BAR'}, 'arg1', 'arg2')
        }.to raise_error(ArgumentError)
      end
    end

    context '([command, argv0], env, arg1, arg2)' do
      it 'raises an ArgumentError' do
        expect {
          SpawnArguments(['command', 'argv0'], {'FOO' => 'BAR'}, 'arg1', 'arg2')
        }.to raise_error(ArgumentError)
      end
    end
  end
end
