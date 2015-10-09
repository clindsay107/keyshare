require 'spec_helper'

describe Keyshare::Loader do

  it "should initialize with a path and default loadable" do
    path = File.expand_path('.')
    loader = Keyshare::Loader.new(path)

    loader.path.must_equal(path)
    loader.loadable.must_equal(ENV)
  end

  it "must require a path to initialize" do
    -> { Keyshare::Loader.new() }.must_raise(ArgumentError)
  end

  it "must require a yml file to exist before loading" do
    loader = Keyshare::Loader.new('spec/resources/i-dont-exist.yml')
    -> { loader.load }.must_raise("No *.yml file found at #{loader.path}")
  end

  it "should be able to load with an arbitrary hash structure" do
    path = File.expand_path('.')
    hash = {}
    loader = Keyshare::Loader.new(path, hash)

    loader.path.must_equal(path)
    loader.loadable.must_equal(hash)
  end

  describe "loading a YAML file into hash structure" do
    before do
      @loadable = {}
      @loader = Keyshare::Loader.new('spec/resources/test.yml', @loadable)
    end

    describe "loading the top-level env if 'development' default doesn't exist" do
      # Load without an env arg
      before { @loader.load }

      it "should load variables from the YAML file to the hash without an env specified in #load call" do
        @loadable['dog'].must_equal('barkley')
      end

      it "should load values as strings" do
        @loadable['cat'].class.must_equal(String)
      end
    end

    describe "specifying an environment in #load call" do
        # Load with production env
        before { @loader.load('production') }

        it "Should be able to read production env variables" do
          @loadable['dog'].must_equal('buddy')
        end
    end
  end

  describe "loading a YAML file into the ENV hash" do
    before do
      @loadable = ENV
      @loader = Keyshare::Loader.new('spec/resources/test.yml', @loadable)
      @loader.load
    end

    it "should load variables into ENV" do
      @loadable.must_equal(ENV)
    end

    it "should be able to get variables from ENV" do
      ENV['dog'].must_equal('barkley')
    end
  end

  describe "unloading the loader" do
    before do
      @loadable = {}
      @loader = Keyshare::Loader.new('spec/resources/test.yml', @loadable)
      @loader.load
    end

    it "Should be able to unload all variables on #unload call" do
      @loader.unload
      assert(@loadable.empty?)
    end

  end
end
