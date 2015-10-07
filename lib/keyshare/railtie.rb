module Keyshare
  class Railtie < Rails::Railtie
    config.before_configuration do
      Keyshare.load(Rails.root.join('config', 'keyshare.yml'), Rails.env)
    end
  end
end
