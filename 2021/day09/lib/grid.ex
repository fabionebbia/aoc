defmodule Grid do
  @enforce_keys [:locs, :rows, :cols]
  defstruct locs: nil, rows: nil, cols: nil

  def new(input) when is_binary(input) do
    lines = String.split(input, "\n", trim: true)

    rows = length(lines)

    cols =
      lines
      |> Enum.at(0)
      |> String.length()

    locs =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, row_index}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {value, col_index}, acc ->
          {value, {row_index, col_index}}
          Map.put(acc, {row_index, col_index}, value)
        end)
      end)

    %__MODULE__{locs: locs, rows: rows, cols: cols}
  end

  def get(%__MODULE__{locs: locs}, row, col) do
    Map.get(locs, {row, col})
  end

  def get_adjacents(%__MODULE__{rows: rows, cols: cols} = grid, row, col) do
    [
      {row - 1, col},
      {row, col + 1},
      {row + 1, col},
      {row, col - 1}
    ]
    |> Enum.reduce([], fn {row, col}, acc ->
      if row >= 0 and row <= rows - 1 and (col >= 0 and col <= cols - 1) do
        value = Grid.get(grid, row, col)
        [{{row, col}, value} | acc]
      else
        acc
      end
    end)
  end

  defimpl Enumerable, for: Grid do
    def count(%Grid{rows: rows, cols: cols}) do
      {:ok, rows * cols}
    end

    def member?(%Grid{locs: locs}, {_row, _col} = coord) do
      {:ok, Map.has_key?(locs, coord)}
    end

    def member?(_grid, _other) do
      {:ok, false}
    end

    def slice(%Grid{locs: locs}) do
      size = map_size(locs)
      {:ok, size, &Enumerable.List.slice(:maps.to_list(locs), &1, &2, size)}
    end

    def reduce(%Grid{locs: locs}, acc, fun) do
      Enumerable.List.reduce(:maps.to_list(locs), acc, fun)
    end
  end
end
