require 'trollop'
require 'opsworks'

class OpsWorks::CLI
  def self.start
    commands = %w(ssh dsh)

    Trollop::options do
      version "opsworks #{OpsWorks::VERSION} " <<
              "(c) #{OpsWorks::AUTHORS.join(", ")}"
      banner <<-EOS.unindent
        usage: opsworks [COMMAND] [OPTIONS...]

        #{OpsWorks::SUMMARY}

        Commands
          ssh       #{OpsWorks::Commands::SSH.banner}
          dsh       #{OpsWorks::Commands::DSH.banner}

        For help with specific commands, run:
          opsworks COMMAND -h/--help

        Options:
      EOS
      stop_on commands
    end

    command = ARGV.shift
    case command
      when "ssh"
        OpsWorks::Commands::SSH.run
      when "dsh"
        OpsWorks::Commands::DSH.run
      when nil
        Trollop::die "no command specified"
      else
        Trollop::die "unknown command: #{command}"
    end

  end
end
