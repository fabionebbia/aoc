defmodule Day12 do
  @doc """
      iex>Day12.part1(\"""
      ...>fs-end
      ...>he-DX
      ...>fs-he
      ...>start-DX
      ...>pj-DX
      ...>end-zg
      ...>zg-sl
      ...>zg-pj
      ...>pj-he
      ...>RW-he
      ...>fs-DX
      ...>pj-RW
      ...>zg-RW
      ...>start-pj
      ...>he-WI
      ...>zg-he
      ...>pj-fs
      ...>start-RW
      ...>\""")
      226
  """
  def part1(input) do
    solve(input, &visit_part_1/1)
  end

  @doc """
      iex>Day12.part2(\"""
      ...>fs-end
      ...>he-DX
      ...>fs-he
      ...>start-DX
      ...>pj-DX
      ...>end-zg
      ...>zg-sl
      ...>zg-pj
      ...>pj-he
      ...>RW-he
      ...>fs-DX
      ...>pj-RW
      ...>zg-RW
      ...>start-pj
      ...>he-WI
      ...>zg-he
      ...>pj-fs
      ...>start-RW
      ...>\""")
      3509
  """
  def part2(input) do
    solve(input, &visit_part_2/1)
  end

  defp solve(input, visit) do
    input
    |> parse_input()
    |> then(visit)
    |> Enum.uniq()
    |> length()
  end

  defp visit_part_1(graph) do
    graph
    |> visit_part_1("start", [], [])
    |> Enum.reverse()
  end

  defp visit_part_1(_, "end", path, acc), do: [Enum.reverse(["end" | path]) | acc]

  defp visit_part_1(graph, node, path, acc) do
    if lowercase?(node) and Enum.member?(path, node) do
      acc
    else
      graph
      |> Map.get(node)
      |> Enum.reduce(acc, fn next_node, acc ->
        visit_part_1(graph, next_node, [node | path], acc)
      end)
    end
  end

  defp visit_part_2(graph) do
    graph
    |> Map.keys()
    |> Enum.filter(fn cave -> cave != "start" and lowercase?(cave) end)
    |> Enum.reduce([], fn small_cave, acc -> visit_part_2(graph, small_cave, acc) end)
  end

  defp visit_part_2(graph, small_cave, acc) do
    visit_part_2(graph, "start", [], small_cave, acc)
  end

  defp visit_part_2(_, "end", path, _, acc), do: [Enum.reverse(["end" | path]) | acc]

  defp visit_part_2(graph, node, path, small_cave, acc) do
    if (node == small_cave and Enum.count(path, &(&1 == small_cave)) == 2) or
         (node != small_cave and lowercase?(node) and Enum.member?(path, node)) do
      acc
    else
      graph
      |> Map.get(node)
      |> Enum.reduce(acc, fn next_node, acc ->
        visit_part_2(graph, next_node, [node | path], small_cave, acc)
      end)
    end
  end

  defp lowercase?(node) do
    node != String.upcase(node)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn link, graph ->
      case link do
        [src, "start"] -> graph_add(graph, "start", src)
        ["end", dest] -> graph_add(graph, dest, "end")
        [src, dest] -> graph_add(graph, src, dest)
      end
    end)
  end

  # I want "start" to only appear as key (starting point)
  # and "end" to only appear as value (end point).
  defp graph_add(graph, src, dest) when src == "start" or dest == "end" do
    Map.update(graph, src, MapSet.new([dest]), &MapSet.put(&1, dest))
  end

  defp graph_add(graph, src, dest) do
    graph
    |> Map.update(src, MapSet.new([dest]), &MapSet.put(&1, dest))
    |> Map.update(dest, MapSet.new([src]), &MapSet.put(&1, src))
  end
end
