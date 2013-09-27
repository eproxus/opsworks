# OpsWorks CLI

Command line interface for Amazon OpsWorks.

## Commands

Run `opsworks` with one of the following commands:

* `ssh` Generate and update SSH configuration files

## Configuration

This gem uses the same configuration file as the [AWS CLI][aws_cli]

Add the following section to the file pointed out by the `AWS_CONFIG_FILE`
environment variable:

    [opsworks]
    stack-id=<MY STACK ID>
    ssh-user-name=<MY SSH USER NAME>

The stack ID can be found in the stack settings, under _OpsWorks ID_. The
`ssh-user-name` value should be set to the username you want to use when logging in
remotely, most probably the user name from your _My Settings_ page on OpsWorks.

## Installation

Install for use on the command line:

    $ gem install opsworks

Then run `opsworks`:

    $ opsworks --help

To use the gem in a project, add this to your `Gemfile`:

    gem 'opsworks'

And then execute:

    $ bundle

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[aws_cli]: http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html "Amazon AWS CLI"
