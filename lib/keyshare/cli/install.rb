require 'thor/group'

module Keyshare
    class Install < Thor::Group
      include Thor::Actions

      # rake install

      class_option :destination,
      desc: "Destination directory for secrets.yml and keyshare.yml",
      aliases: ["-d", "--destination"],
      required: true

      def self.source_root
        File.expand_path("../install", __FILE__)
      end

      def copy
        raise "Must provide destination directory!" if !options[:destination]

        copy_file("example.secrets.yml", "#{options[:destination]}/example.secrets.yml")
        copy_file("example.keyshare.yml", "#{options[:destination]}/example.keyshare.yml")
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
