# The method signatures for exec, system, & spawn are identical and complicated.
# This is a helper method that extracts the env vars hash, command, and options hash components.
# I've called it SpawnArguments even though it's the same signature for exec, spawn, and system
# because the Ruby docs for exec and system refer to the docs for spawn, indicating that Ruby
# considers spawn the "origin" of the signature.
def SpawnArguments(*args)
  # the env vars hash is either the first argument, or empty
  env = if args.first.is_a?(Hash)
          args.shift
        else
          {}
        end

  # the options hash is either the last argument, or empty
  options = if args.last.is_a?(Hash)
              args.pop
            else
              {}
            end

  raise(ArgumentError, "You must provide a command to run.") if args.empty?

  command = args.shift

  raise(
    ArgumentError,
    "Unable to recognize first command component. Expected String or Array, got #{args.first.class}."
  ) unless command.is_a?(String) || command.is_a?(Array)

  raise(
    ArgumentError,
    "Each command component after the first must be strings."
  ) unless args.all? { |arg| arg.is_a?(String) }

  if args.empty?
    if command.is_a?(String) # single commandline string
      [env, command, options]
    elsif command.is_a?(Array)
      [env, [command], options] # [command, argv0] pair with no other command arguments
    end
  else
    # this covers
    #   a command with multiple string arguments
    # and
    #   a [command, argv0] pair with multiple string arguments
    [env, [command, *args], options]
  end
end
