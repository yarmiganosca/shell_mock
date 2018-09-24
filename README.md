# ShellMock
[![Gem Version](https://badge.fury.io/rb/shell_mock.png)](http://badge.fury.io/rb/shell_mock)
[![Build Status](https://secure.travis-ci.org/yarmiganosca/shell_mock.png)](http://travis-ci.org/yarmiganosca/shell_mock)

It's [webmock](http://github.com/bblimke/webmock) for shell commands. It's pretty simple. You can do things like this:

```ruby
require 'shell_mock/rspec'

RSpec.describe "shelling out to run 'ls'" do
  before { ShellMock.enable }
  after  { ShellMock.disable }

  let(:stub) { ShellMock.stub_command('ls') }

  it "works"
    expect(system('ls')).to eq true

    expect(stub).to have_been_called
  end
end
```

This:
1. enables ShellMock's monkey patches during the test
2. creates a command stub that will match the command `"ls"` (by default it will exit `0` and have no output)
3. shells out to run `"ls"` (in this case using `Kernel#system`)
4. correctly expects that our command stub for `"ls"` will have recorded an invocation

### You can narrow what invocations are matched to your command stub:

**Match env vars as well as the command:** `ShellMock.stub_command('ls').with_env({'FOO' => 'bar'})`

**Provide a more complete invocation:** `ShellMock.stub_command('ls $HOME')`

Shelling out to run `"ls"` won't match this command stub, but shelling out to run `"ls $HOME"` will. ShellMock always matches as strictly as possible, so if you stubbed `"ls"` and `"ls $HOME"`, invocations of `"ls $HOME'` would only ever match against the latter.

### Setting the behavior of the command invocation:

**Have the mock command invocation write to stdout:** `ShellMock.stub_command('ls').and_output("\n")`

**Set the mock command invocation's exit status:** `ShellMock.stub_command('ls').and_exit(2)`

If you want to both write to stdout and set the exit code (a common pair), `ShellMock.stub_command('ls').and_return("\n")` will both have the command invocation write the passed string to stdout, and will set the mock command invocation's exit status to `0`.

### Specifying the expected number of command invocations:

**Called exactly once:** `expect(stub).to have_been_called.once`

**Not called:** `expect(stub).to have_been_called.never`

**Not called (using RSpec expectation negation):** `expect(stub).to_not have_been_called`

**Called exactly `n` times:** `expect(stub).to have_been_called.times(n)`

**Called more than `n` times:** `expect(stub).to have_been_called.more_than(n)`

**Called fewer than `n` times:** `expect(stub).to have_been_called.fewer_than(n)`

`less_than` can be used as an alias for `fewer_than`
## Limitations

Currently, only exact string matches of the stubbed command string are supported. Basic regex support or more complex matching for arguments and flags may be added later.

ShellMock supports stubbing these ways of shelling out in Ruby:
* [`` Kernel#` ``](https://ruby-doc.org/core/Kernel.html#method-i-60) (aka "backticks")
* [`%x` command literal](https://ruby-doc.org/docs/ruby-doc-bundle/Manual/man-1.4/syntax.html#command) (which delegates to backticks)
* [`Kernel#system`](https://ruby-doc.org/core/Kernel.html#method-i-system)
* [`Kernel#exec`](https://ruby-doc.org/core/Kernel.html#method-i-exec)
* [`Kernel#spawn`](https://ruby-doc.org/core/Kernel.html#method-i-spawn)
* [`Process.spawn`](https://ruby-doc.org/core/Process.html#method-c-spawn)
* [the `Open3` module](https://ruby-doc.org/stdlib/libdoc/open3/rdoc/Open3.html) (since all its methods use `spawn`)

ShellMock currently DOES NOT support stubbing these ways of shelling out in Ruby (but will):
* [`IO.popen`](https://ruby-doc.org/core/IO.html#method-c-popen)
* [`PTY.spawn`](https://ruby-doc.org/stdlib/libdoc/pty/rdoc/PTY.html#method-c-spawn)
* [passing a string that starts with `"|"`](https://devver.wordpress.com/2009/07/13/a-dozen-or-so-ways-to-start-sub-processes-in-ruby-part-2/) to [`Kernel#open`](https://ruby-doc.org/core/Kernel.html#method-i-open)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shell_mock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shell_mock

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yarmiganosca/shell_mock. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
