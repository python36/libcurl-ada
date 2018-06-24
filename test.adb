with ada.text_io;
with libcurl;

procedure test is
  use type libcurl.curl_code;

  c : libcurl.curl;
  r : libcurl.curl_code;

  f : libcurl.file_io.file_type;
begin
  c := libcurl.curl_easy_init; -- инициализируем
  r := libcurl.curl_easy_setopt_long(c, libcurl.curlopt_verbose, 0); -- без отладочной инфы
  r := libcurl.curl_easy_setopt_long(c, libcurl.curlopt_timeout, 5); -- таймаут
  r := libcurl.curl_easy_setopt_string(c, libcurl.curlopt_useragent, "ada_libcurl"); -- useragent
  r := libcurl.curl_easy_setopt_write_callback(
    c, libcurl.curlopt_writefunction, libcurl.writer'Access); -- ссылка на функцию которая записывает, другой пример этой функции см. дальше
  r := libcurl.curl_easy_setopt_string(c, libcurl.curlopt_url,
    "https://upload.wikimedia.org/wikipedia/commons/a/a4/Ada_Lovelace_portrait.jpg"); -- url
  libcurl.file_io.create(file => f, mode => libcurl.file_io.out_file,
    name => "ada.jpg"); -- создаем файл на запись. нужно обрабатывать на ошибки
  r := libcurl.curl_easy_setopt_write_data(c, libcurl.curlopt_writedata, f); -- userdata - это то что будет передано в функцию writefunction, в этом случае это файл
  if libcurl.curl_easy_perform(c) /= 0 then -- если не 0 смотреть в документации
    ada.text_io.put_line("error perform:" & r'img);
    libcurl.file_io.close(f);
    return;
  end if;
  libcurl.file_io.close(f); -- закрываем файл
  ada.text_io.put_line("return code:" & natural'image(
    libcurl.curl_easy_getinfo_natural(c, libcurl.curlinfo_response_code))); -- получаем код ответа и выводим его
  libcurl.curl_easy_cleanup(c); -- закрываем и очищаем
end test;