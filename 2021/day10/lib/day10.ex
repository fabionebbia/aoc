defmodule Day10 do
  @illegal_points %{
    ?) => 3,
    ?] => 57,
    ?} => 1197,
    ?> => 25137
  }

  @incomplete_points %{
    ?) => 1,
    ?] => 2,
    ?} => 3,
    ?> => 4
  }

  @doc """
      iex>Day10.part1(\"""
      ...>[({(<(())[]>[[{[]{<()<>>
      ...>[(()[<>])]({[<{<<[]>>(
      ...>{([(<{}[<>[]}>{[]{[(<()>
      ...>(((({<>}<{<{<>}{[]{[]{}
      ...>[[<[([]))<([[{}[[()]]]
      ...>[{[{({}]{}}([{[{{{}}([]
      ...>{<[[]]>}<{[{[{[]{()[[[]
      ...>[<(<(<(<{}))><([]([]()
      ...><{([([[(<>()){}]>(<<{{
      ...><{([{{}}[<[[[<>{}]]]>[]]
      ...>\""")
      26397
  """
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(fn subsystem -> visit(subsystem, []) end)
    |> Enum.filter(&(elem(&1, 0) == :illegal))
    |> Enum.map(fn {_, paren} -> @illegal_points[paren] end)
    |> Enum.sum()
  end

  @doc """
      iex>Day10.part2(\"""
      ...>[({(<(())[]>[[{[]{<()<>>
      ...>[(()[<>])]({[<{<<[]>>(
      ...>{([(<{}[<>[]}>{[]{[(<()>
      ...>(((({<>}<{<{<>}{[]{[]{}
      ...>[[<[([]))<([[{}[[()]]]
      ...>[{[{({}]{}}([{[{{{}}([]
      ...>{<[[]]>}<{[{[{[]{()[[[]
      ...>[<(<(<(<{}))><([]([]()
      ...><{([([[(<>()){}]>(<<{{
      ...><{([{{}}[<[[[<>{}]]]>[]]
      ...>\""")
      288957
  """
  def part2(input) do
    points =
      input
      |> parse_input()
      |> Enum.map(fn subsystem -> visit(subsystem, []) end)
      |> Enum.filter(&(elem(&1, 0) == :incomplete))
      |> Enum.map(fn {_, expected} ->
        expected
        |> Enum.map(&@incomplete_points[&1])
        |> Enum.reduce(0, fn points, score ->
          score * 5 + points
        end)
      end)
      |> Enum.sort()

    Enum.at(points, div(length(points), 2))
  end

  defp visit([opening | input], expected) when opening in [?(, ?[, ?{, ?<] do
    visit(input, [pair(opening) | expected])
  end

  defp visit([closing | input], [closing | expected]) do
    visit(input, expected)
  end

  defp visit([illegal | _], _), do: {:illegal, illegal}
  defp visit([], expected), do: {:incomplete, expected}

  defp pair(?(), do: ?)
  defp pair(paren) when paren in [?[, ?{, ?<], do: paren + 2

  defp parse_input(input) when is_binary(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&to_charlist/1)
  end
end
