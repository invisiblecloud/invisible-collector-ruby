# Invoice Capture API Ruby client

[![Gem Version](https://badge.fury.io/rb/invoice_capture.svg)](http://badge.fury.io/rb/invoice_capture)
[![Travis Badge](https://travis-ci.org/invisiblecloud/invoice-capture-ruby.svg?branch=master)](https://travis-ci.org/invisiblecloud/invoice-capture-ruby)
[![Code Climate](https://codeclimate.com/github/invisiblecloud/invoice-capture-ruby.svg)](https://codeclimate.com/github/invisiblecloud/invoice-capture-ruby)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'invoice_capture'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install invoice_capture

## Usage

If necessary include it in you ruby code:

```ruby
require 'invoice_capture'
```

You'll need to retrieve an access token from Invoice Capture's dashboard.

With your access token you can instantiate a new client with it:

```ruby
client = InvoiceCapture::API.new(api_token: 'YOUR_TOKEN')
```

## Resources

### Company resource

```ruby
client = InvoiceCapture::API.new(api_token: 'YOUR_TOKEN')
client.company #=> InvoiceCapture::CompanyResource
```

Actions supported:

* `client.company.get()`

### Customer resource

```ruby
client = InvoiceCapture::API.new(api_token: 'YOUR_TOKEN')
client.customer #=> InvoiceCapture::CustomerResource
```

Actions supported:

* `client.customer.find(:attribute_hash)`
* `client.customer.get(:id)`

### Alarm resource

```ruby
client = InvoiceCapture::API.new(api_token: 'YOUR_TOKEN')
client.alarm #=> InvoiceCapture::AlarmResource
```

Actions supported:

* `client.alarm.close(:id)`
* `client.alarm.get(:id)`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/invisiblecloud/invoice-capture-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

1. Fork it ( https://github.com/invisiblecloud/invoice-capture-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
