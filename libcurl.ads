with System;
with Interfaces.C;
with Interfaces.C.Strings;
with Interfaces.C.Pointers;
with Ada.Sequential_IO;
with ada.strings.unbounded;

package libcurl is
  package unb renames ada.strings.unbounded;
  use type unb.unbounded_string;

  package C renames Interfaces.C;
  package Strings renames Interfaces.C.Strings;

  use type interfaces.c.size_t;
  use type interfaces.c.int;

  subtype int is interfaces.c.int;
  subtype chars_ptr is interfaces.c.strings.chars_ptr;
  subtype size_t is interfaces.c.size_t;

  subtype curl is system.address;

  type curl_option is new int;
  type curl_info is new int;
  type curl_code is new interfaces.c.int;

  function curl_easy_init return curl;
  pragma import (c, curl_easy_init, "curl_easy_init");

  function curl_easy_perform (handle : in curl) return curl_code;
  pragma import (c, curl_easy_perform, "curl_easy_perform");

  function curl_easy_setopt_string (handle : in curl; opt : in curl_option; val : in string) return curl_code;
  function curl_easy_getinfo_natural (handle : in curl; inf : in curl_info) return natural;
  -- function curl_easy_getinfo_float (handle : in curl; inf : in curl_info) return float;

  curlopt_url : curl_option;
  pragma import (C, curlopt_url, "_curlopt_url");

  curle_ok : Integer;
  pragma import (c, curle_ok, "_curle_ok");

  curlopt_verbose : curl_option;
  pragma import (c, curlopt_verbose, "_curlopt_verbose");

  curlopt_writefunction : curl_option;
  pragma import (c, curlopt_writefunction, "_curlopt_writefunction");

  curlopt_writedata : curl_option;
  pragma import (c, curlopt_writedata, "_curlopt_writedata");

  curlopt_proxy : curl_option;
  pragma import (c, curlopt_proxy, "_curlopt_proxy");

  curlopt_ssl_verifypeer : curl_option;
  pragma import (c, curlopt_ssl_verifypeer, "_curlopt_ssl_verifypeer");

  curlopt_ssl_verifyhost : curl_option;
  pragma import (c, curlopt_ssl_verifyhost, "_curlopt_ssl_verifyhost");

  curlopt_useragent : curl_option;
  pragma import (c, curlopt_useragent, "_curlopt_useragent");

  curlopt_timeout : curl_option;
  pragma import (c, curlopt_timeout, "_curlopt_timeout");

  curlinfo_response_code : curl_info;
  pragma import (c, curlinfo_response_code, "_curlinfo_response_code");

  curlinfo_size_download : curl_info;
  pragma import (c, curlinfo_size_download, "_curlinfo_size_download");

  function curl_easy_setopt_long (
    handle : in curl; option : in curl_option; value : in interfaces.c.long) return curl_code;
  pragma import (c, curl_easy_setopt_long, "curl_easy_setopt");

  function curl_easy_getinfo_long (
    handle : in curl; option : in curl_info; value : access c.long) return curl_code;
  pragma import (c, curl_easy_getinfo_long, "curl_easy_getinfo");

  -- function curl_easy_getinfo_double (
  --   handle : in curl; option : in curl_info; value : access c.double) return curl_code;
  -- pragma import (c, curl_easy_getinfo_double, "curl_easy_getinfo");

  procedure curl_easy_cleanup (handle : in curl);
  pragma import (c, curl_easy_cleanup, "curl_easy_cleanup");

  package char_ptrs is new interfaces.c.pointers (
    index => interfaces.c.size_t,
    element => interfaces.c.char,
    element_array => interfaces.c.char_array,
    default_terminator => c.nul);
  use type char_ptrs.pointer;
  subtype char_star is char_ptrs.pointer;

  package file_io is new ada.sequential_io(interfaces.c.char);

  function writer (
    ptr : in char_star; size : in size_t;
    nmemb : in size_t; userdata : in file_io.file_type) return size_t;
  pragma convention (c, writer);

  type write_callback_access is access function (
    ptr  : in char_star; size : in size_t;
    nmemb : in size_t; userdata : in file_io.file_type) return size_t;
  pragma convention (c, write_callback_access);

  function curl_easy_setopt_write_callback (
    handle : in curl; option : in curl_option;
    func : in write_callback_access) return curl_code;
  pragma import (c, curl_easy_setopt_write_callback, "curl_easy_setopt");

  function curl_easy_setopt_write_data (
    handle : in curl; option : in curl_option;
    pointer : in file_io.file_type) return curl_code;
  pragma import (c, curl_easy_setopt_write_data, "curl_easy_setopt");

  function reader (
    ptr : in char_star; size : in size_t;
    nmemb : in size_t; userdata : access unb.unbounded_string) return size_t;
  pragma convention (c, reader);

  type read_callback_access is access function (
    ptr  : in char_star; size : in size_t;
    nmemb : in size_t; userdata : access unb.unbounded_string) return size_t;
  pragma convention (c, read_callback_access);

  function curl_easy_setopt_read_callback (
    handle : in curl; option : in curl_option;
    func : in read_callback_access) return curl_code;
  pragma import (c, curl_easy_setopt_read_callback, "curl_easy_setopt");

  function curl_easy_setopt_read_data (
    handle : in curl; option : in curl_option;
    pointer : access unb.unbounded_string) return curl_code;
  pragma import (c, curl_easy_setopt_read_data, "curl_easy_setopt");

private

  function curl_easy_setopt (
    handle : in curl; option : in curl_option; value : in chars_ptr) return curl_code;
  pragma import (c, curl_easy_setopt, "curl_easy_setopt");

end libcurl;