require 'trollop'
require 'opsworks'

class OpsWorks::CLI
  def self.start
    spec = Gem::Specification::load(File.expand_path(
      "../../../opsworks.gemspec",
      Pathname.new(__FILE__).realpath,
    ))

    commands = %w(ssh)

    global_opts = Trollop::options do
      version "opsworks #{spec.version} (c) #{spec.authors.join(", ")}"
      banner <<-EOS.unindent
        usage: opsworks [COMMAND] [OPTIONS...]

        #{spec.summary}

        Commands
          ssh       #{OpsWorks::Commands::SSH.banner}

        For help with specific commands, run:
          opsworks COMMAND -h/--help

        Options:
      EOS
      stop_on commands
    end

    command = ARGV.shift
    command_opts = case command
      when "ssh"
        OpsWorks::Commands::SSH.run
      when nil
        Trollop::die "no command specified"
      else
        Trollop::die "unknown command: #{command}"
    end

  end
end