# Copyright 2014 LKC Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

defmodule Nerves.WpaSupplicant.Messages do

  def encode(cmd) when is_atom(cmd) do
    to_string(cmd)
  end
  def encode({:"CTRL-RSP-IDENTITY", network_id, string}) do
    "CTRL-RSP-IDENTITY-#{network_id}-#{string}"
  end
  def encode({:"CTRL-RSP-PASSWORD", network_id, string}) do
    "CTRL-RSP-PASSWORD-#{network_id}-#{string}"
  end
  def encode({:"CTRL-RSP-NEW_PASSWORD", network_id, string}) do
    "CTRL-RSP-NEW_PASSWORD-#{network_id}-#{string}"
  end
  def encode({:"CTRL-RSP-PIN", network_id, string}) do
    "CTRL-RSP-PIN-#{network_id}-#{string}"
  end
  def encode({:"CTRL-RSP-OTP", network_id, string}) do
    "CTRL-RSP-OTP-#{network_id}-#{string}"
  end
  def encode({:"CTRL-RSP-PASSPHRASE", network_id, string}) do
    "CTRL-RSP-PASSPHRASE-#{network_id}-#{string}"
  end
  def encode({cmd, arg}) when is_atom(cmd) do
    to_string(cmd) <> " " <> encode_arg(arg)
  end
  def encode({cmd, arg, arg2}) when is_atom(cmd) do
    to_string(cmd) <> " " <> encode_arg(arg) <> " " <> encode_arg(arg2)
  end
  def encode({cmd, arg, arg2, arg3}) when is_atom(cmd) do
    to_string(cmd) <> " " <> encode_arg(arg) <> " " <> encode_arg(arg2) <> " " <> encode_arg(arg3)
  end

  defp encode_arg(arg) when is_binary(arg) do
    if String.length(arg) == 17 &&
      Regex.match?(~r/[\da-fA-F][\da-fA-F]:[\da-fA-F][\da-fA-F]:[\da-fA-F][\da-fA-F]:[\da-fA-F][\da-fA-F]:[\da-fA-F][\da-fA-F]:[\da-fA-F][\da-fA-F]/, arg) do
      # This is a MAC address
      arg
    else
      # This is a string
      "\"" <> arg <> "\""
    end
  end
  defp encode_arg(arg) do
    to_string(arg)
  end

  @doc """
  Decode notifications from the wpa_supplicant
  """
  def decode_notif(<< "CTRL-REQ-", rest::binary >>) do
    [field, net_id, text] = String.split(rest, "-", parts: 3, trim: true)
    {String.to_atom("CTRL-REQ-" <> field), String.to_integer(net_id), text}
  end
  def decode_notif(<< "CTRL-EVENT-BSS-ADDED", rest::binary >>) do
    [entry_id, bssid] = String.split(rest, " ", trim: true)
    {:"CTRL-EVENT-BSS-ADDED", String.to_integer(entry_id), bssid}
  end
  def decode_notif(<< "CTRL-EVENT-BSS-REMOVED", rest::binary >>) do
    [entry_id, bssid] = String.split(rest, " ", trim: true)
    {:"CTRL-EVENT-BSS-REMOVED", String.to_integer(entry_id), bssid}
  end
  def decode_notif(<< "CTRL-EVENT-CONNECTED", _rest::binary >>) do
    :"CTRL-EVENT-CONNECTED"
  end
  def decode_notif(<< "CTRL-EVENT-DISCONNECTED", _rest::binary >>) do
    :"CTRL-EVENT-DISCONNECTED"
  end
  def decode_notif(<< "CTRL-EVENT-", _type::binary>> = event) do
    event |> String.trim_trailing |> String.to_atom
  end
  def decode_notif(<< "WPS-", _type::binary>> = event) do
    event |> String.trim_trailing |> String.to_atom
  end
  def decode_notif(<< "AP-STA-CONNECTED ", mac::binary>>) do
    {:"AP-STA-CONNECTED", String.trim_trailing(mac)}
  end
  def decode_notif(<< "AP-STA-DISCONNECTED ", mac::binary>>) do
    {:"AP-STA-DISCONNECTED", String.trim_trailing(mac)}
  end
  def decode_notif(string) do
    {:INFO, String.trim_trailing(string)}
  end

  @doc """
  Decode responses from the wpa_supplicant

  The decoding of a response depends on the request, so pass the request as
  the first argument and the response as the second one.
  """
  def decode_resp(req, resp) do
    # Strip the response of whitespace before trying to parse it.
    tresp(req, String.trim(resp))
  end

  defp tresp(:PING, "PONG"), do: :PONG
  defp tresp(:MIB, resp), do: kv_resp(resp)
  defp tresp(:STATUS, resp), do: kv_resp(resp)
  defp tresp(:"STATUS-VERBOSE", resp), do: kv_resp(resp)
  defp tresp({:BSS, _}, ""), do: nil
  defp tresp({:BSS, _}, resp), do: kv_resp(resp)
  defp tresp(:INTERFACES, resp), do: String.split(resp, "\n")
  defp tresp(:ADD_NETWORK, netid), do: String.to_integer(netid)
  defp tresp(_, "OK"), do: :ok
  defp tresp(_, "FAIL"), do: :FAIL
  defp tresp(_, << "\"", string::binary >>), do: String.trim_trailing(string, "\"")
  defp tresp(_, resp), do: resp

  defp kv_resp(resp) do
    resp
      |> String.split("\n", trim: true)
      |> List.foldl(%{}, fn(pair, acc) ->
           [key, value] = String.split(pair, "=")
           Map.put(acc, String.to_atom(key), kv_value(String.trim_trailing(value)))
         end)
  end

  defp kv_value("TRUE"), do: true
  defp kv_value("FALSE"), do: false
  defp kv_value(""), do: nil
  defp kv_value(<< "0x", hex::binary >>), do: kv_value(hex, 16)
  defp kv_value(str), do: kv_value(str, 10)

  defp kv_value(value, base) do
    try do
      String.to_integer(value, base)
    rescue
      ArgumentError -> value
    end
  end

end
