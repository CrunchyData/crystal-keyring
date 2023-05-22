require "./keychain/*"
require "./libsecret/*"

module Keyring
  extend self

  class NotAvailable < Exception
  end

  def set(service : String, account : String, password : String, label : String? = nil) : Bool
    {% if flag?(:darwin) %}
      Keychain.set(label: label, service: service, account: account, password: password)
    {% else %}
      raise NotAvailable.new
    {% end %}
  end

  def get(service : String, account : String) : String
    {% if flag?(:darwin) %}
      Keychain.get(service: service, account: account)
    {% else %}
      raise NotAvailable.new
    {% end %}
  end

  def delete(service : String, account) : Bool
    {% if flag?(:darwin) %}
      Keychain.delete(service: service, account: account)
    {% else %}
      raise NotAvailable.new
    {% end %}
  end
end
