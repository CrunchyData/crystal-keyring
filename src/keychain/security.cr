@[Link(framework: "Security")]
lib Security
  $kSecClass : Void*
  $kSecClassGenericPassword : Void*

  $kSecAttrAccessGroup : Void*
  $kSecAttrAccount : Void*
  $kSecAttrLabel : Void*
  $kSecAttrService : Void*

  $kSecReturnData : Void*

  $kSecValueData : Void*

  enum OSStatus : Int32
    ErrSecSuccess       =      0
    ErrSecUserCanceled  =   -128
    ErrSecDuplicateItem = -25299
    ErrSecItemNotFound  = -25300
  end

  fun sec_item_add = SecItemAdd(attributes : Void*, result : Void*) : OSStatus
  fun sec_item_copy_matching = SecItemCopyMatching(query : Void*, result : Void*) : OSStatus
  fun sec_item_delete = SecItemDelete(query : Void*) : OSStatus
  fun sec_item_update = SecItemUpdate(query : Void*, attributes : Void*) : OSStatus
  fun sec_copy_error_message_string = SecCopyErrorMessageString(Void*, Void*) : Void*
end
