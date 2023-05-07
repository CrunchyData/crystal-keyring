require "./keyring"

label = "Crunchy Bridge CLI"
service = "api.crunchydata.com"
account = "adam.brightwell@crunchydata.com"

Keyring.set(service, account, "12345", label)

puts Keyring.get(service, account)

Keyring.delete(service, account)
