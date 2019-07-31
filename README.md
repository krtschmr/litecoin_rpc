LitecoinRPC

    gem "litecoin_rpc", github: "krtschmr/litecoin_rpc"

Always develop in testnet!

    LitecoinRPC.config.network = Rails.env.production? ? :livenet : :testnet
    LitecoinRPC.config.debug = !Rails.env.production?


    client = LitecoinRPC.new( "test", "test", host: "192.168.0.200", port: 1337)
    client.listtransactions.each do |tx|
      tx_id = tx["txid"]
      address = tx["address"]
      amount = tx["amount"]
      confirmations = tx["confirmations"]  
      # do something
    end
