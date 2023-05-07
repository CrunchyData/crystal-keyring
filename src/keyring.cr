require "./keychain/*"
require "./libsecret/*"

module Keyring
  extend self

  def set(service : String, account : String, password : String, label : String? = nil)
    {% if flag?(:darwin) %}
      Keychain.set(label: label, service: service, account: account, password: password)
    {% else %}
    {% end %}
  end

  def get(service : String, account : String) : String
    {% if flag?(:darwin) %}
      Keychain.get(service: service, account: account)
    {% else %}
    {% end %}
  end

  def delete(service : String, account) : Bool
    {% if flag?(:darwin) %}
      Keychain.delete(service: service, account: account)
    {% else %}
    {% end %}
  end
end
