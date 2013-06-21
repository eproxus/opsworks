require 'trollop'
require 'opsworks/config'
require 'aws-sdk'
require 'awesome_print'

class OpsWorks::CLI
  def self.start
    opts = Trollop::options do
    end

    config = OpsWorks.config

    client = AWS::OpsWorks::Client.new

    stack = client.describe_stacks().stacks.find do
      |stack| stack.stack_id == config.stack_id
    end
    ap stack
  end
end