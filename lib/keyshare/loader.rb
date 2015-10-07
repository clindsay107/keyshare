module Keyshare
  class Loader
    attr_reader :path, :loadable

    # `loadable` can be anything that is a hash structure, default to ENV container
    def initialize(path, loadable = ENV)
      @path = File.expand_path(path)
      @loadable = loadable
    end

    def load(env = 'development')
      if @yml ||= load_yml
        @yml.each { |k,v| set_value(k, v) }
        if @yml[env]
          @yml[env].each { |k,v| set_value(k,v) }
        end
      end
    end

    def unload
      if @yml
        @yml.clear
      end

      @loadable.clear
    end

    private

    def load_yml
      File.exist?(@path) ? YAML.load_file(@path) : raise "No *.yml file found at #{@path}"
    end

    def set_value(k, v)
      @loadable[k.to_s] = v.to_s unless v.is_a?(Hash)
    end

  end
end
