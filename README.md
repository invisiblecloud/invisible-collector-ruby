# Invisible Collector API Ruby client

[![Gem Version](https://badge.fury.io/rb/invisible_collector.svg)](http://badge.fury.io/rb/invisible_collector)
[![Travis Badge](https://travis-ci.org/invisiblecloud/invisible-collector-ruby.svg?branch=master)](https://travis-ci.org/invisiblecloud/invisible-collector-ruby)
[![Code Climate](https://codeclimate.com/github/invisiblecloud/invisible-collector-ruby.svg)](https://codeclimate.com/github/invisiblecloud/invisible-collector-ruby)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'invisible_collector'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install invisible_collector

## Usage

If necessary include it in you ruby code:

```ruby
require 'invisible_collector'
```

You'll need to retrieve an access token from Invisible Collector's dashboard.

With your access token you can instantiate a new client with it:

```ruby
client = InvisibleCollector::API.new(api_token: 'YOUR_TOKEN')
```

## Resources

### Company resource

```ruby
client = InvisibleCollector::API.new(api_token: 'YOUR_TOKEN')
client.company #=> InvisibleCollector::CompanyResource
```

Actions supported:

* `client.company.get()`

### Customer resource

```ruby
client = InvisibleCollector::API.new(api_token: 'YOUR_TOKEN')
client.customer #=> InvisibleCollector::CustomerResource
```

Actions supported:

* `client.customer.find(:attribute_hash)`
* `client.customer.get(:id)`
* `client.customer.update(:attribute_hash)`

### Debt resource

```ruby
client = InvisibleCollector::API.new(api_token: 'YOUR_TOKEN')
client.debt #=> InvisibleCollector::DebtResource
```

Actions supported:

* `client.debt.find(:attribute_hash)`
* `client.debt.get(:id)`
* `client.debt.save(:attribute_hash)`
* `client.debt.suspend(:debt)`
* `client.debt.unsuspend(:debt)`

### Alarm resource

```ruby
client = InvisibleCollector::API.new(api_token: 'YOUR_TOKEN')
client.alarm #=> InvisibleCollector::AlarmResource
```

Actions supported:

* `client.alarm.close(:id)`
* `client.alarm.get(:id)`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/invisiblecloud/invisible-collector-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

1. Fork it ( https://github.com/invisiblecloud/invisible-collector-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
