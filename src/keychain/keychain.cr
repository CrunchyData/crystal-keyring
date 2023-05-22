module Keychain
  extend self

  class ItemDuplicate < Exception
  end

  class ItemNotFound < Exception
  end

  # Add a security item to the keychain.
  def set(service : String, account : String, password : String, label : String? = nil) : Bool
    service = CoreFoundation.string_create_with_c_string(nil, service, CoreFoundation::StringEncoding::UTF8)
    account = CoreFoundation.string_create_with_c_string(nil, account, CoreFoundation::StringEncoding::UTF8)
    password = CoreFoundation.string_create_with_c_string(nil, password, CoreFoundation::StringEncoding::UTF8)

    attrs = CoreFoundation.mutable_dictionary_create(nil, 0, nil, nil)
    CoreFoundation.dictionary_add_value(attrs, Security.kSecClass, Security.kSecClassGenericPassword)
    CoreFoundation.dictionary_add_value(attrs, Security.kSecAttrService, service)
    CoreFoundation.dictionary_add_value(attrs, Security.kSecAttrAccount, account)
    CoreFoundation.dictionary_add_value(attrs, Security.kSecValueData, password)

    if label
      label = CoreFoundation.string_create_with_c_string(nil, label, CoreFoundation::StringEncoding::UTF8)
      CoreFoundation.dictionary_add_value(attrs, Security.kSecAttrLabel, label)
    end

    status = Security.sec_item_add(attrs, nil)

    case status
    when Security::OSStatus::ErrSecSuccess
      return true
    when Security::OSStatus::ErrSecDuplicateItem
      raise ItemDuplicate.new
    end

    return false
  end

  # Get the value of a security item from the keychain.
  def get(service : String, account : String) : String
    service = CoreFoundation.string_create_with_c_string(nil, service, CoreFoundation::StringEncoding::UTF8)
    account = CoreFoundation.string_create_with_c_string(nil, account, CoreFoundation::StringEncoding::UTF8)

    query = CoreFoundation.mutable_dictionary_create(nil, 0, nil, nil)
    CoreFoundation.dictionary_add_value(query, Security.kSecClass, Security.kSecClassGenericPassword)
    CoreFoundation.dictionary_add_value(query, Security.kSecAttrService, service)
    CoreFoundation.dictionary_add_value(query, Security.kSecAttrAccount, account)
    CoreFoundation.dictionary_add_value(query, Security.kSecReturnData, CoreFoundation.kCFBooleanTrue)

    result = uninitialized CoreFoundation::CFData
    status = Security.sec_item_copy_matching(query, pointerof(result))

    case status
    when Security::OSStatus::ErrSecSuccess
      result_ptr = CoreFoundation.data_get_byte_ptr(result)
      result_length = CoreFoundation.data_get_length(result)
      return String.new(result_ptr, result_length)
    when Security::OSStatus::ErrSecItemNotFound
      raise ItemNotFound.new
    else
      raise Exception.new "something else"
    end
  end

  # Delete a security item from the keychain.
  def delete(service : String, account : String) : Bool
    service = CoreFoundation.string_create_with_c_string(nil, service, CoreFoundation::StringEncoding::UTF8)
    account = CoreFoundation.string_create_with_c_string(nil, account, CoreFoundation::StringEncoding::UTF8)

    query = CoreFoundation.mutable_dictionary_create(nil, 0, nil, nil)
    CoreFoundation.dictionary_add_value(query, Security.kSecClass, Security.kSecClassGenericPassword)
    CoreFoundation.dictionary_add_value(query, Security.kSecAttrService, service)
    CoreFoundation.dictionary_add_value(query, Security.kSecAttrAccount, account)

    status = Security.sec_item_delete(query)

    case status
    when Security::OSStatus::ErrSecSuccess
      return true
    when Security::OSStatus::ErrSecItemNotFound
      raise ItemNotFound.new
    else
      raise Exception.new("Unhandled: #{status}")
    end
  end

  # Update a security item in the keychain.
  def update(service : String, account : String, password : String)
  end
end
