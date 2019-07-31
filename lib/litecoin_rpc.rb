require 'litecoin_rpc/client'
require 'litecoin_rpc/config'

module LitecoinRPC
  def self.config
    @@config ||= LitecoinRPC::Config.instance
  end
  def self.new(user, password, args={})
     Client.new(user, password, args)
   end
end

LitecoinRPC.config.network = Rails.env.production? ? :livenet : :testnet
LitecoinRPC.config.debug = !Rails.env.production?
