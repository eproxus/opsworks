require "opsworks/meta"
require "opsworks/config"
require "opsworks/commands/file_util"
require "opsworks/commands/ssh"
require "opsworks/commands/dsh"

class String
  def unindent
    gsub(/^#{self[/\A\s*/]}/, '')
  end
end

module OpsWorks
end
