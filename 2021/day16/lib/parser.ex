defmodule Day16.Parser do
  @operators %{
    0 => :sum,
    1 => :product,
    2 => :min,
    3 => :max,
    # 4 => literal
    5 => :greater_than,
    6 => :less_than,
    7 => :equal_to
  }

  def parse(input) do
    {parsed, _rest} =
      input
      |> hex_to_bin()
      |> do_parse()

    parsed
  end

  # Literal.
  defp do_parse(<<version::size(3), 4::size(3), rest::bitstring>>) do
    {value, size, rest} = parse_value(rest, <<>>)
    # Adding 6 to size to keep track of the version and type id bits
    {{:literal, version, size + 6, value}, rest}
  end

  # Operator.
  defp do_parse(<<version::size(3), operator::size(3), rest::bitstring>>) do
    {value, size, rest} = parse_operator(rest)
    # Adding 6 to size to keep track of the version and type id bits
    {{@operators[operator], version, size + 6, value}, rest}
  end

  # Literal value.
  # First bit == 1 -> keep reading.
  # First bit == 0 -> last group.
  defp parse_value(<<keep_reading::size(1), group::size(4), rest::bitstring>>, acc) do
    acc = <<acc::bitstring, (<<group::size(4)>>)>>

    if keep_reading == 1 do
      parse_value(rest, acc)
    else
      size = bit_size(acc)
      <<value::size(size)>> = acc
      # Adding size / 4 to size to keep track of any keep_reading bit encountered
      {value, size + round(size / 4), rest}
    end
  end

  # Operator.
  # Mode: total sub-packets length in bits.
  defp parse_operator(<<0::size(1), length::size(15), rest::bitstring>>) do
    packets =
      Stream.unfold({length, rest}, fn {length, rest} ->
        if length != 0 do
          {{_type, _version, size, _value} = packet, rest} = do_parse(rest)
          {packet, {length - size, rest}}
        else
          nil
        end
      end)
      |> Enum.to_list()

    <<_::size(length), rest::bitstring>> = rest
    # Adding 16 to keep track of the mode and length bits
    {packets, length + 16, rest}
  end

  # Operator.
  # Mode: number of sub-packets.
  defp parse_operator(<<1::size(1), packet_count::size(11), rest::bitstring>>) do
    {packets, rest} = Enum.map_reduce(1..packet_count, rest, fn _, rest -> do_parse(rest) end)
    size = Enum.reduce(packets, 0, fn {_type, _version, size, _value}, acc -> acc + size end)
    # Adding 12 to keep track of the mode and packet count bits
    {packets, size + 12, rest}
  end

  defp hex_to_bin(input) do
    bits = String.to_integer(input, 16)
    size = byte_size(input)
    <<bits::size(size)-unit(4)>>
  end
end
