defmodule GoogleSheets.Utils do

  # Converts a binary value to hex string (md5 = 128 bits, sha1 = 160 bits, sha256 = 256 bits and sha512 = 512 bits)
  def hexstring(<<x::size(128)>>), do: to_string(hd(:io_lib.format("~32.16.0b",  [x])))
  def hexstring(<<x::size(160)>>), do: to_string(hd(:io_lib.format("~40.16.0b",  [x])))
  def hexstring(<<x::size(256)>>), do: to_string(hd(:io_lib.format("~64.16.0b",  [x])))
  def hexstring(<<x::size(512)>>), do: to_string(hd(:io_lib.format("~128.16.0b", [x])))

end
