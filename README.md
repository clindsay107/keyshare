# Keyshare
[![Build Status](https://travis-ci.org/clindsay107/keyshare.svg?branch=master)](https://travis-ci.org/clindsay107/keyshare)

"It's like LastPass for your Ruby application!"

A Ruby gem to securely share and manage credentials used for various services, API calls and webhooks in your Ruby application.
No longer do you need to store secret keys and tokens in a YAML file to be passed around offline to every project member. Keyshare
encrypts and stores your credentials on Amazon S3, then automatically fetches and injects them into your application. This means
that the only credentials you need to pass around are your Amazon AWS credentials and your keyshare master password.

Keyshare also includes a command-line tool called [Gatekeeper](cli). This gives basic functionality for
adding/removing/retrieving credentials stored on S3.

## Prerequisites

- An AWS account (free tier is more than adequate).

Keyshare uses S3 buckets as keyrings to store your encrypted data. You will also
need your AWS access key ID and secret access key which can be obtained from the [AWS Security Credentials tab](https://console.aws.amazon.com/iam/home?#security_credential).

- OpenSSL of *at least* version 1.0.2d **or** 1.0.1p.

For instructions of how to check/update your OpenSSL version, see [this document](openssl-update.md)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'keyshare'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install keyshare

## Usage

TODO: Write usage instructions here

## Testing

**NOTE** You will need to have your `env.yml` credentials set for tests to run.

You can test core (Keyshare) components with:

    $ rake test

You can test Gatekeeper with:

    $ rake test_gatekeeper

And you can run both Gatekeeper and Keyshare tests with:

    $ rake test_all

See the [Gatekeeper docs here](cli/README.md) for more info on testing Gatekeeper.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` or `rake test_gatekeeper` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/clindsay107/keyshare.
