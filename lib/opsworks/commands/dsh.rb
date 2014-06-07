require 'aws-sdk'
require 'trollop'

require 'opsworks'

DSH_PREFIX  = "# --- OpsWorks ---"
DSH_POSTFIX = "# --- End of OpsWorks ---"

module OpsWorks::Commands
  class DSH
    def self.banner
      "Generate and update DSH configuration files"
    end

    def self.run
      options = Trollop::options do
        banner <<-EOS.unindent
          #{DSH.banner}

          Options:
        EOS
        opt :update, "Update ~/.dsh config files directly"
        opt :backup, "Backup old DSH config before updating"
      end

      config = OpsWorks.config

      client = AWS::OpsWorks::Client.new

      instances = []
      layers_by_stack = {}
      instances_by_layer = {}

      config.stacks.each do |stack_id|
        result = client.describe_stacks(stack_ids: [stack_id])
        stack_name = result.stacks.first.name

        result = client.describe_instances(stack_id: stack_id)
        instances += result.instances.select { |i| i[:status] != "stopped" }

        layers_by_stack[stack_name] = []
        result = client.describe_layers(stack_id: stack_id)
        layers_by_stack[stack_name] += result.layers


        instances_by_layer[stack_name] = {}

        layers_by_stack[stack_name].each do |layer|
          layer_inst = []
          result = client.describe_instances(layer_id: layer[:layer_id])
          layer_inst = result.instances.select { |i| i[:status] != "stopped" }

          layer_inst.map! do |instance|
            instance[:hostname]
          end

          instances_by_layer[stack_name][layer[:shortname]] =
                         "\n\n#{DSH_PREFIX}\n" <<
                         "#{layer_inst.join("\n")}\n" <<
                         "#{DSH_POSTFIX}\n\n"

#          puts layer[:shortname]
#          puts instances_by_layer[stack_name][layer[:shortname]]
        end
        layers_by_stack[stack_name].map! do |layer|
          layer[:shortname]
        end
      end

      instances.reject! { |i| i[:elastic_ip].nil? && i[:public_ip].nil? }
      instances.map! do |instance|
        instance[:hostname]
      end

      new_machine_contents = "\n\n#{DSH_PREFIX}\n" <<
                     "#{instances.join("\n")}\n" <<
                     "#{DSH_POSTFIX}\n\n"

      if options[:update]
        dsh_config_dir = "#{ENV['HOME']}/.dsh"

        machines_list = "#{dsh_config_dir}/machines.list"
        groups_dir = "#{dsh_config_dir}/group"

        [dsh_config_dir, groups_dir].each do |dir|
          unless Dir.exists? dir
            Dir.mkdir dir
          end
        end

        if options[:backup]
          OpsWorks::Commands::FileUtil.backup(dsh_config_dir)
        end

        OpsWorks::Commands::FileUtil.update_file(machines_list, new_machine_contents)
        puts "Successfully updated #{machines_list} with " <<
             "#{instances.length} instances!"

        layers_by_stack.keys.each do |stack|
          puts stack
          layers_by_stack[stack].each do |layer|
            puts layer
            contents = instances_by_layer[stack][layer]
            group_file = "#{groups_dir}/#{stack}_#{layer}"
            puts group_file
            OpsWorks::Commands::FileUtil.update_file(group_file, contents)
            puts "Successfully updated group/#{group_file}!"
          end
        end

        puts "Successfully updated #{machines_list} with " <<
             "#{instances.length} instances!"
      else
        puts new_machine_contents.strip
      end
    end
  end
end
