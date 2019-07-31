require 'singleton'
module LitecoinRPC
  class Config
    include Singleton
    attr_accessor :network, :debug
  end
end
