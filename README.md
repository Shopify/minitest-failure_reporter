# Minitest::FailureReporter

Generates a json file that includes test failures and is compatible with ci-queue's failure file.

The format of the file looks as follows:

```ruby
[{
  test_file_path: String,
  test_line: Int,
  test_id: String,
  test_name: String,
  test_suite: String,
  error_class: String,
  error_message: String,
  output: String,
}]
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minitest_failure-reporter'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install minitest_failure-reporter

## Usage

```
--failure-reporter # Generate a failure json report
--failure-reporter-filename=OUT # Target output filename. Defaults to failure_file.json
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Shopify/minitest_failure-reporter.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
