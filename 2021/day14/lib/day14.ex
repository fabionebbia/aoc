defmodule Day14 do
  @doc """
      iex>Day14.solve(\"""
      ...>NNCB
      ...>
      ...>CH -> B
      ...>HH -> N
      ...>CB -> H
      ...>NH -> C
      ...>HB -> C
      ...>HC -> B
      ...>HN -> C
      ...>NN -> C
      ...>BH -> H
      ...>NC -> B
      ...>NB -> B
      ...>BN -> B
      ...>BB -> N
      ...>BC -> B
      ...>CC -> N
      ...>CN -> C
      ...>\""", 40)
      2188189693529
  """
  def solve(input, steps) do
    {template, rules} = parse_input(input)

    <<last_polymer::utf8>> =
      input
      |> String.split("\n\n")
      |> Enum.at(0)
      |> String.at(-1)

    {{_, min}, {_, max}} =
      template
      |> polymerize(rules, steps)
      |> Enum.reduce(%{}, fn {pair, frequency}, acc ->
        Map.update(acc, hd(pair), frequency, &(&1 + frequency))
      end)
      |> Map.update(last_polymer, 1, &(&1 + 1))
      |> Enum.min_max_by(fn {_, frequency} -> frequency end)

    max - min
  end

  defp polymerize(template, _rules, 0) do
    template
  end

  defp polymerize(template, rules, steps) do
    template
    |> Enum.reduce(%{}, fn {pair, frequency}, acc ->
      rules
      |> Map.get(pair, pair)
      |> Enum.reduce(acc, fn ins, acc ->
        Map.update(acc, ins, frequency, &(&1 + frequency))
      end)
    end)
    |> polymerize(rules, steps - 1)
  end

  defp parse_input(input) do
    [template | [rules]] = String.split(input, "\n\n", parts: 2)

    template =
      template
      |> to_charlist()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.frequencies()

    rules =
      rules
      |> String.split(["\n", " -> "], trim: true)
      |> Enum.chunk_every(2)
      |> Enum.reduce(%{}, fn [pair, <<insertion::utf8>>], acc ->
        pair = [e0, e1] = to_charlist(pair)
        insertion = [[e0, insertion], [insertion, e1]]

        Map.put(acc, pair, insertion)
      end)

    {template, rules}
  end
end
