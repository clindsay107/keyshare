module Keyshare
  class Railtie < Rails::Railtie
    rake_tasks do
      load("tasks/keyshare.rake")
    end

    config.before_configuration do
      Keyshare.load(Rails.root.join("config", "secrets.yml"), Rails.env)
    end
  end
end
