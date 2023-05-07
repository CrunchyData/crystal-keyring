@[Link(framework: "CoreFoundation")]
lib CoreFoundation
  type CFData = Void*
  type CFDictionary = Void*

  enum StringEncoding
    UTF8 = 134217984
  end

  $kCFBooleanTrue : Void*

  # CFData
  fun data_create = CFDataCreate(allocator : Void*, bytes : UInt8*, length : UInt32) : CFData
  fun data_get_byte_ptr = CFDataGetBytePtr(data : CFData) : UInt8*
  fun data_get_length = CFDataGetLength(data : CFData) : UInt32

  # CFDictionary
  fun mutable_dictionary_create = CFDictionaryCreateMutable(allocator : Void*, capacity : UInt32, keyCallbacks : Void*, valueCallbacks : Void*) : Void*
  fun dictionary_add_value = CFDictionaryAddValue(dict : Void*, key : Void*, value : Void*)
  #   fun dictionary_get_value = CFDictionaryGetValue(dict : CFDictionary, key : Void*) : Void*

  # CFString
  fun string_create_with_c_string = CFStringCreateWithCString(allocator : Void*, str : UInt8*, encoding : UInt32) : Void*
  fun string_get_length = CFStringGetLength(Void*) : UInt32
end
