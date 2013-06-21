require 'inifile'

module OpsWorks
  def self.config
    @config ||= Config.new
  end

  class Config
    attr_reader :stack_id

    def initialize
      ini = IniFile.load(ENV["AWS_CONFIG_FILE"])

      aws_config = ini['default']
      AWS.config(
        access_key_id: aws_config["aws_access_key_id"],
        secret_access_key: aws_config["aws_secret_access_key"],
      )

      @stack_id = ini['opsworks']['stack-id']
    end
  end
end
