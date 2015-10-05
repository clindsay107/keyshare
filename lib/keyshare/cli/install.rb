require 'thor/group'

module Keyshare
    class Install < Thor::Group
      include Thor::Actions

      class_option "path",
      aliases: ["-p"],
      default: "config/keyshare.yml",
      desc: "Specify a path for your keyshare.yml file to be created"

      def self.source_root
        File.expand_path("../install", __FILE__)
      end

      def copy_base_yml
        puts "Called!"
        copy_file("default.yml", options[:path])
      end

      def add_to_ignore
        puts "Please add #{options[:path]} to your project .gitignore file to avoid committing secrets to version control!"
      end

      # def add_to_ignore
      #   # Shell out to find top level dir
      #   root_dir = `git rev-parse --show-toplevel`
      #   if File.exists?("#{root_dir}/.gitignore")
      #     append_to_file(".gitignore", <<-EOF)
      #     # Ignore keyshare.yml secrets file
      #     /#{options[:path]}
      #     EOF
      #   end
      # end
    end
end
