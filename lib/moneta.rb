require 'httpi'
require 'pry-debugger'

module Moneta
  class Eterminal

    def initialize(*args)
      return self if args.empty?
      params_hash = args[0]
      key_file      = params_hash[:key_file]
      key_pwd       = params_hash[:key_pwd]
      cert_file     = params_hash[:cert_file]
      ca_cert_file  = params_hash[:ca_cert_file]
      wsdl_path     = params_hash[:wsdl_file]
      @namespace    = params_hash[:namespace]
      ::HTTPI::Adapter.use = :net_http

      @client = Savon::Client.new do
        wsdl.document = wsdl_path
        http.auth.ssl.verify_mode = :none
        http.auth.ssl.cert_key_file = key_file
        http.auth.ssl.cert_key_password = key_pwd
        http.auth.ssl.cert_file = cert_file
        http.auth.ssl.ca_cert_file = ca_cert_file
        http.headers = {
          "User-Agent" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13 (.NET CLR 3.5.30729)",
          "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
          "Accept-Language" => "sl,en-us;q=0.7,en;q=0.3",
          "Accept-Encoding" => "gzip, deflate",
          "Accept-Charset" => "ISO-8859-1,utf-8;q=0.7,*;q=0.7",
          "Keep-Alive" => "115",
          "Connection" => "Keep-Alive"
          }
      end
    end

    def login(*args)
      soap_body = args.first
      savon_call(:log_in, soap_body).to_hash
    rescue Exception => ex
      {error_code: -1, error_description: ex.message}
    end

    def token(*args)
      soap_body = args.first
      savon_call(:get_token, soap_body).to_hash #amount should be in format "x.xx CURRENCY"
    rescue Exception => ex
      { error_code: -1, error_description: ex.message }
    end

    def transaction_status(*args)
      soap_body = args.first
      savon_call(:get_transaction_status, soap_body).to_hash
    rescue Exception => ex
      {error_code: -1, error_description: ex.message}
    end

    def transaction_list(*args)
      soap_body = args.first
      savon_call(:get_transaction_list, soap_body).to_hash
    rescue Exception => ex
      {error_code: -1, error_description: ex.message}
    end

    def reverse(*args)
      soap_body = args.first
      savon_call(:reverse, soap_body).to_hash
    rescue Exception => ex
      {error_code: -1, error_description: ex.message}
    end

    def cancel_transaction(*args)
      soap_body = args.first
      savon_call(:cancel_transaction, soap_body).to_hash
    rescue Exception => ex
      {error_code: -1, error_description: ex.message}
    end

    private

    def savon_call(method, body)
      envelope = @client.request :soap, method, :xmlns => @namespace do
        soap.body = body unless body.empty?
      end
    end
  end
end
