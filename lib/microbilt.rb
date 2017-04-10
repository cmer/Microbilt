require 'microbilt/version'
require 'microbilt/customer'
require 'microbilt/requests'

module Microbilt
  autoload :Configuration, 'microbilt/configuration'

  class << self
    attr_writer :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
