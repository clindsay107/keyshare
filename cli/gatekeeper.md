# Gatekeeper

Gatekeeper is a CLI tool included with `keyshare` that provides a quick way to
create a new Keyshare vault, add credentials, get (and decrypt) stored credentials,
and delete credentials.

## Testing

Gatekeeper has it's own separate test suite built with Minitest. You can run all
specs from the top level `keyshare` directory with `rake test_gatekeeper`.

**NOTE** You will need to have your `env.yml` credentials set for Gatekeeper tests to run.

## AWS Errors

Gatekeeper (and Keyshare) leverage the `aws-sdk` gem for S3 interaction. All errors from the `aws-sdk` gem inherit from the parent [`Aws::Errors::ServiceError`](http://docs.aws.amazon.com/sdkforruby/api/Aws/Errors/ServiceError.html).
Most errors that get raised have a self-explanatory name, but in the event that you find an error that you don't understand,
this page should be able to explain it.
