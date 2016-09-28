# ShellMock

It's [webmock](http://github.com/bblimke/webmock) for shell commands. It's pretty simple. You can do things like this:

```ruby
require 'shell_mock/rspec'

describe 'something' do
  stub = ShellMock.stub_command('ls').and_return("\n")

  # something that involves shelling out & calling ls

  expect(stub).to have_been_called
end
```

More complex expectations are also supported.

Called exactly once: `expect(stub).to have_been_called.once`

Not called: `expect(stub).to_not have_been_called` or `expect(stub).to have_been_called.never`

Called exactly `n` times: `expect(stub).to have_been_called.times(n)`

Called more than `n` times: `expect(stub).to have_been_called.more_than(n)`

Called fewer than `n` times: `expect(stub).to have_been_called.fewer_than(n)`
`less_than` is also an alias for `fewer_than`.

Right now, only exact command string matches are supported.

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

