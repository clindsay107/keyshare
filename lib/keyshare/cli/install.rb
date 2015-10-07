require 'thor/group'

module Keyshare
    class Install < Thor::Group
      include Thor::Actions

      # rake install

      class_option :destination,
      aliases: ["-d", "--destination"],
      default: "config/secrets.yml",
      desc: "Specify a destination path for your secrets.yml file to be created"

      class_option :source,
      aliases: ["-s", "--source"],
      desc: "Specify an optional, existing YAML secrets file to be copied to env.yml"

      def self.source_root
        File.expand_path("../install", __FILE__)
      end

      def copy
        if options[:source]
          already_exists! if File.exist?(source[:destination])
          copy_file(File.expand_path(options[:source]), File.expand_path(options[:destination]))
        else
          say("Created file #{File.expand_path(options[:destination])}")
          copy_file("default.yml", File.expand_path(options[:destination]))
        end
      end

      def add_to_ignore
        say("\nPlease add #{options[:destination]} to your project .gitignore file now to avoid committing secrets to version control!", [:red, :bold], true)
      end

      private

      def already_exists!(destination)
        raise "A secrets.yml file already exists at #{destination}! Please backup and (re)move this file before re-running the rake task."
      end

    end
end
