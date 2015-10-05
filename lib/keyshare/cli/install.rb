require 'thor/group'

module Keyshare
    class Install < Thor::Group
      include Thor::Actions
      # rake install

      class_option :destination,
      aliases: ["-d", "--destination"],
      default: "config/keyshare.yml",
      desc: "Specify a destination path for your keyshare.yml file to be created"

      class_option :source,
      aliases: ["-s", "--source"],
      desc: "Specify an optional, existing YAML secrets file to be copied to keyshare.yml"

      def self.source_root
        File.expand_path("../install", __FILE__)
      end

      def copy
        if options[:source]
          copy_file(File.expand_path(options[:source]), File.expand_path(options[:destination]))
        else
          copy_file("default.yml", File.expand_path(options[:destination]))
        end
      end

      def add_to_ignore
        say("\nPlease add #{options[:path]} to your project .gitignore file now to avoid committing secrets to version control!", [:red, :bold], true)
      end

    end
end
