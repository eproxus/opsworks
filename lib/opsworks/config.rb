require 'inifile'

module OpsWorks
  def self.config
    @config ||= Config.new
  end

  class Config
    attr_reader :stacks, :ssh_user_name

    def initialize
      file = ENV["AWS_CONFIG_FILE"] || "#{ENV['HOME']}/.aws/config"
      raise "AWS config file not found" unless File.exists? file
      ini = IniFile.load(file)

      aws_config = ini['default']
      AWS.config(
        access_key_id: aws_config["aws_access_key_id"],
        secret_access_key: aws_config["aws_secret_access_key"],
      )

      @stacks = ini['opsworks']['stack-id'].split(',').map(&:strip)
      @ssh_user_name = ini['opsworks']['ssh-user-name'].strip
    end
  end
end
