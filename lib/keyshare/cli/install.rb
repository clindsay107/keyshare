require 'thor/group'

module Keyshare
    class Install < Thor::Group
      include Thor::Actions

      # rake install

      class_option :destination,
      aliases: ["-d", "--destination"],
      required: true,
      desc: "Specify a destination path for secrets.yml and keyshare.yml"

      class_option :source,
      aliases: ["-s", "--source"],
      default: "install/example.secrets.yml"
      desc: "Specify an optional, existing YAML secrets file to be copied to secrets.yml"

      def self.source_root
        File.expand_path("../install", __FILE__)
      end

      def copy
        raise "Must provide destination directory!" if !options[:destination]

        copy_file(File.expand_path(options[:source]), File.expand_path(options[:destination]))
        copy_file(File.expand_path("install/example.keyshare.yml"), File.expand_path(options[:destination]))
      end

      def add_to_ignore
        say("\nPlease add keyshare.yml and secrets.yml to your project .gitignore file now to avoid committing secrets to version control!", [:red, :bold], true)
      end

      private

      def already_exists!(destination)
        raise "A secrets.yml file already exists at #{destination}! Please backup and (re)move this file before re-running the rake task."
      end

    end
end
