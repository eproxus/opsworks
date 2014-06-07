require 'FileUtils'
require 'trollop'

require 'opsworks'

module OpsWorks::Commands
  class FileUtil

    def self.backup (source)
      if File.exists? source
        base_name = source + ".backup"
        if File.exists? base_name
          number = 0
          backup = "#{base_name}-#{number}"
          while base_name.class.exists? backup
            backup = "#{base_name}-#{number += 1}"
          end
        else
          backup = base_name
        end

        FileUtils.cp_r(source, backup)
      end
    end

    def self.update_file (f, new_contents)
      options = Trollop::options

      old_contents = (File.exists? f) ? File.read(f) : ""

      File.open(f, "w") do |file|
        unless old_contents == ""
          file.puts old_contents.gsub(
            /\n?\n?#{SSH_PREFIX}.*#{SSH_POSTFIX}\n?\n?/m,
            ''
          )
        end
        file.puts new_contents
      end
    end
  end
end
