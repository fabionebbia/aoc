defmodule Day16 do
  alias Day16.{Evaluator, Parser}

  @doc """
      iex>Day16.part1("A0016C880162017C3686B18A3D4780")
      31
  """
  def part1(input) do
    input
    |> Parser.parse()
    |> sum_version_numbers()
  end

  @doc """
      iex>Day16.part2("9C0141080250320F1802104A08")
      1
  """
  def part2(input) do
    input
    |> Parser.parse()
    |> Evaluator.eval()
  end

  defp sum_version_numbers(nodes) when is_list(nodes),
    do: Enum.reduce(nodes, 0, fn node, sum -> sum + sum_version_numbers(node) end)

  defp sum_version_numbers({:literal, version, _size, _value}),
    do: version

  defp sum_version_numbers({_operator, version, _size, value}),
    do: version + sum_version_numbers(value)
end
