@[Link("secret-1")]
@[Link("glib-2.0")]
lib LibSecret
  SECRET_COLLECTION_DEFAULT = "default"

  struct Error
    domain : LibC::UInt32T
    code : LibC::Int
    message : LibC::Char*
  end

  # Secret Schema
  enum SchemaFlags
    NONE            = 0
    DONT_MATCH_NAME = 1
  end

  enum SchemaType
    NOTE           = 0
    COMPAT_NETWORK = 1
  end

  struct Schema
    name : LibC::Char*
    flags : SchemaFlags
    attributes : StaticArray(SchemaAttribute, 32)
  end

  fun schema_new = secret_schema_new(name : LibC::Char*, flags : SchemaFlags, ...) : Schema*
  fun schema_unref = secret_schema_unref(schema : Schema*) : Void

  # Schema Attribute
  enum SchemaAttributeType
    STRING  = 0
    INTEGER = 1
    BOOLEAN = 2
  end

  struct SchemaAttribute
    name : LibC::Char*
    type : SchemaAttributeType
  end

  # Secret Service
  enum SecretServiceFlags
    NONE             = 0
    OPEN_SESSION     = 1
    LOAD_COLLECTIONS = 2
  end

  alias SecretService = Void*

  fun service_get_sync = service_get_sync(flags : SecretServiceFlags, cancellable : Void*, error : Error**) : SecretService*

  # Secret Collection
  enum SecretCollectionCreateFlags
    NONE       = 0
    LOAD_ITEMS = 1
  end

  fun collection_create_sync = secret_collection_create_sync(service : SecretService*, label : LibC::Char*, alias : LibC::Char*, flags : SecretCollectionCreateFlags, cancellable : Void*, error : Error**)

  # Password Storage
  fun password_clear_sync = secret_password_clear_sync(schema : Schema*, cancellable : Void*, error : Error*, ...) : Bool
  fun password_store_sync = secret_password_store_sync(schema : Schema*, collection : LibC::Char*, label : LibC::Char*, password : LibC::Char*, cancellable : Void*, error : Error*, ...) : Bool
  fun password_lookup_sync = secret_password_lookup_sync(schema : Schema*, cancellable : Void*, error : Error*, ...) : LibC::Char*
  fun password_free = secret_password_free(password : LibC::Char*)

  fun error_get_quark = secret_error_get_quark : UInt32

  fun quark_to_string = g_quark_to_string(quark : UInt32) : LibC::Char*
  fun quark_try_string = g_quark_try_string(quark : LibC::Char*) : UInt32
end

def string_attribute(name : String) : LibSecret::SchemaAttribute
  attr = LibSecret::SchemaAttribute.new
  attr.name = name
  attr.type = LibSecret::SchemaAttributeType::STRING
  attr
end

# begin
#   schema = LibSecret.schema_new(
#     "org.freedesktop.Secret.Generic",
#     LibSecret::SchemaFlags::NONE,
#     string_attribute("service"),
#     string_attribute("account"),
#     nil
#   )

#   error = LibSecret::Error.new
#   ok = LibSecret.password_store_sync(
#     schema,
#     LibSecret::SECRET_COLLECTION_DEFAULT, # collection
#     "Crunchy Bridge CLI",                 # label
#     "it's a secret",                      # password
#     nil,                                  # cancellable
#     pointerof(error),                     # error
#     "service", "api.crunchybridge.com",
#     "account", "adam.brightwell@crunchydata.com",
#     nil, # null terminate list
#   )

#   puts ok

#   password = LibSecret.password_lookup_sync(
#     schema,
#     nil,
#     nil,
#     "service", "api.crunchybridge.com",
#     "account", "adam.brightwell@crunchydata.com",
#     nil)

#   puts String.new(password)
# rescue exception
#   puts exception
# end
