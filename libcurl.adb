with interfaces.c.strings;
with ada.text_io;

package body libcurl is

  function curl_easy_setopt_string (handle : in curl; opt : in curl_option; val : in string) return curl_code is
  begin
    return curl_easy_setopt (handle, opt, interfaces.c.strings.new_string(val));
  end curl_easy_setopt_string;

  function curl_easy_getinfo_natural (handle : in curl; inf : in curl_info) return natural is
    val : aliased interfaces.c.long;
    res : curl_code;
  begin
    res := curl_easy_getinfo_long(handle, inf, val'access);
    return natural(val);
  end curl_easy_getinfo_natural;

  -- function curl_easy_getinfo_float (handle : in curl; inf : in curl_info) return float is
  --   val : aliased interfaces.c.double;
  --   res : curl_code;
  -- begin
  --   res := curl_easy_getinfo_double(handle, inf, val'access);
  --   return float(val);
  -- end curl_easy_getinfo_float;

  function writer (
      ptr : in char_star; size : in size_t;
      nmemb : in size_t; userdata : in file_io.file_type) return libcurl.size_t is

    total : constant libcurl.size_t := size * nmemb;
    c_char : c.char;
    pointer : char_star;
   begin
      pointer := ptr;
      for i in 1..integer(total) loop
        c_char := pointer.all;
        file_io.write(userdata, c_char);
        char_ptrs.increment(pointer);
      end loop;
      return total;
   end writer;

  function reader (
      ptr : in char_star; size : in size_t;
      nmemb : in size_t; userdata : access unb.unbounded_string) return libcurl.size_t is
    total : constant libcurl.size_t := size * nmemb;
  begin
    unb.append(userdata.all, unb.to_unbounded_string(
      interfaces.c.strings.value(interfaces.c.strings.new_char_array(
        char_ptrs.value(ptr)))));
    return total;
  end reader;

end libcurl;