module SaveTogether
  module Configuration
    def notifications
      SaveTogether::Notifications
    end
  end

  module Notifications
    class << self
      attr_accessor :donors
      attr_accessor :savers
      attr_accessor :organizations
    end
  end
end

Rails::Configuration.send :include, SaveTogether::Configuration
