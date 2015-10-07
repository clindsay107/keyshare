require 'thor/group'

module Keyshare
    class Install < Thor::Group
      include Thor::Actions
      
      # rake install

      class_option :destination,
      aliases: ["-d", "--destination"],
      default: "config/env.yml",
      desc: "Specify a destination path for your env.yml file to be created"

      class_option :source,
      aliases: ["-s", "--source"],
      desc: "Specify an optional, existing YAML secrets file to be copied to env.yml"

      def self.source_root
        File.expand_path("../install", __FILE__)
      end

      def copy
        already_exists! if File.exist?(source[:destination])

        if !options[:source].empty?
          copy_file(File.expand_path(options[:source]), File.expand_path(options[:destination]))
        else
          say("Created file #{File.expand_path(options[:destination])}", :green)
          copy_file("default.yml", File.expand_path(options[:destination]))
        end
      end

      def add_to_ignore
        say("\nPlease add #{options[:path]} to your project .gitignore file now to avoid committing secrets to version control!", [:red, :bold], true)
      end

      private

      def already_exists!(destination)
        raise "An env.yml file already exists at #{destination}! Please backup and (re)move this file before re-running the rake task."
      end

    end
end
