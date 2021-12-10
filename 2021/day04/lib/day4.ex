defmodule Day4 do
  @doc """
      iex> Day4.part1(\"""
      ...>7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
      ...>
      ...>22 13 17 11  0
      ...>8  2 23  4 24
      ...>21  9 14 16  7
      ...>6 10  3 18  5
      ...>1 12 20 15 19
      ...>
      ...>3 15  0  2 22
      ...>9 18 13 17  5
      ...>19  8  7 25 23
      ...>20 11 10 24  4
      ...>14 21 16 12  6
      ...>
      ...>14 21 17 24  4
      ...>10 16 15  9 19
      ...>18  8 23 26 20
      ...>22 11 13  6  5
      ...>2  0 12  3  7
      ...>\""")
      4512
  """
  def part1(input) when is_binary(input) do
    {random_numbers, boards} = parse_input(input)
    play_part_1(random_numbers, boards)
  end

  @doc """
      iex> Day4.part2(\"""
      ...>7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
      ...>
      ...>22 13 17 11  0
      ...>8  2 23  4 24
      ...>21  9 14 16  7
      ...>6 10  3 18  5
      ...>1 12 20 15 19
      ...>
      ...>3 15  0  2 22
      ...>9 18 13 17  5
      ...>19  8  7 25 23
      ...>20 11 10 24  4
      ...>14 21 16 12  6
      ...>
      ...>14 21 17 24  4
      ...>10 16 15  9 19
      ...>18  8 23 26 20
      ...>22 11 13  6  5
      ...>2  0 12  3  7
      ...>\""")
      1924
  """
  def part2(input) when is_binary(input) do
    {random_numbers, boards} = parse_input(input)
    play_part_2(random_numbers, boards, nil)
  end

  defp play_part_1([number | random_numbers], boards) do
    result =
      Enum.reduce_while(boards, {:nowin, []}, fn board, {_, acc} ->
        new_board = play_board(number, board)

        if wins?(new_board) do
          {:halt, {:win, new_board}}
        else
          {:cont, {:nowin, [new_board | acc]}}
        end
      end)

    case result do
      {:nowin, new_boards} ->
        play_part_1(random_numbers, Enum.reverse(new_boards))

      {:win, winning_board} ->
        winning_board
        |> List.flatten()
        |> Enum.filter(&(&1 != -1))
        |> Enum.sum()
        |> Kernel.*(number)
    end
  end

  defp play_part_2([], _, last_result), do: last_result
  defp play_part_2(_, [], last_result), do: last_result

  defp play_part_2([number | random_numbers], boards, last_result) do
    {new_boards, new_result} =
      Enum.reduce(boards, {[], last_result}, fn board, {new_boards_acc, last_result} ->
        new_board = play_board(number, board)

        if not wins?(new_board) do
          {[new_board | new_boards_acc], last_result}
        else
          new_result =
            new_board
            |> List.flatten()
            |> Enum.filter(&(&1 != -1))
            |> Enum.sum()
            |> Kernel.*(number)

          {new_boards_acc, new_result}
        end
      end)

    play_part_2(random_numbers, Enum.reverse(new_boards), new_result)
  end

  defp play_board(number, board) do
    new_board =
      Enum.reduce(board, [], fn row, rows_acc ->
        new_row =
          Enum.reduce(row, [], fn elem, elems_acc ->
            new_elem = if elem == number, do: -1, else: elem
            [new_elem | elems_acc]
          end)

        [Enum.reverse(new_row) | rows_acc]
      end)

    Enum.reverse(new_board)
  end

  defp wins?(board) do
    if Enum.any?(board, &row_wins?/1) do
      true
    else
      board
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.any?(&row_wins?/1)
    end
  end

  defp row_wins?(row) do
    Enum.all?(row, &(&1 == -1))
  end

  defp parse_input(input) do
    [random_numbers | boards] = String.split(input, "\n\n", trim: true)

    random_numbers = parse_random_numers(random_numbers)
    boards = Enum.map(boards, &parse_board/1)

    {random_numbers, boards}
  end

  defp parse_random_numers(numbers) when is_binary(numbers) do
    numbers
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_board(board) when is_binary(board) do
    board
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
