require 'inifile'

module OpsWorks
  def self.config
    @config ||= Config.new
  end

  class Config
    attr_reader :stack_id, :ssh_user_name

    def initialize
      ini = IniFile.load(ENV["AWS_CONFIG_FILE"])

      aws_config = ini['default']
      AWS.config(
        access_key_id: aws_config["aws_access_key_id"],
        secret_access_key: aws_config["aws_secret_access_key"],
      )

      @stack_id = ini['opsworks']['stack-id']
      @ssh_user_name = ini['opsworks']['ssh-user-name']
    end
  end
end
