require "opsworks/version"
require "opsworks/config"
require "opsworks/commands/ssh"

class String
  def unindent
    gsub(/^#{self[/\A\s*/]}/, '')
  end
end

module Opsworks
end
