require 'net/http'
require 'uri'
require 'json'

module LitecoinRPC
  class Client
    class Unauthenticated < StandardError;end;

    attr_accessor :user, :password, :host, :port, :network, :debug

    def initialize(user, password, args={})
      self.network = args.fetch(:network, LitecoinRPC.config.network)
      raise ::ArgumentError.new("unknown network :#{network}") unless [:livenet, :testnet].map(&:to_s).include?(network.to_s)

      self.user = user
      self.password = password
      self.host = args.fetch(:host, "localhost")
      self.port = args.fetch(:port, "19332")
      self.debug = args.fetch(:debug, LitecoinRPC.config.debug || false)
    end

    def validateaddress(address)
      request(:validateaddress, address)
    end

    def importaddress(address, label, rescan=false)
      request(:importaddress, address, label, rescan)
    end

    # def importmulti(data, rescan=false)
    # This shit isn't working at all ! annoying
    #   request(:importmulti, data, {rescan: rescan})
    # end

    # data.collect{|a,l| { scriptPubKey: { "address": a }, watchonly: true, timestamp: 1.day.ago.to_i } }

    def rescanblockchain(start_height=1_565_000)
      #livenet start 580_000
      request(:rescanblockchain, start_height)
    end

    def getconnectioncount
      request(:getconnectioncount)
    end


    def listtransactions(include_sending = false)
      txs = request(:listtransactions, "*", 100, 0, true)
      if include_sending
        txs
      else
        txs.select{|tx|
          tx['category'] == "receive"
        }
      end
    end

    def gettransaction(txid)
      request(:gettransaction, txid, true)
    end


    private

    def base_uri
      "http://#{host}:#{port}/"
    end

    def request(method, *args)
      uri = URI.parse(base_uri)
      header = {'Content-Type': 'text/json'}
      params = {
        jsonrpc: 1.0,
        method: method,
        params: [args].flatten.compact
      }

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.basic_auth(user, password)
      request.body = params.to_json
      if debug
        p "sending request to #{uri}, method: #{method}, args: #{args}" unless Rails.env.test?
      end
      if Rails.env.test?
        return "ok"
      end
      response = http.request(request)

      if response.code == "403"
        raise Unauthenticated
      end

      json = JSON.parse(response.body)
      if json["error"]
        raise "#{json["error"]["code"]} | message: #{json["error"]["message"]}"
      end
      json["result"]
    end

  end
end
