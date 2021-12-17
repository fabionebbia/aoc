defmodule Day16.Evaluator do
  def eval({:literal, _, _, value}), do: value

  def eval({:sum, _, _, values}), do: map_then(values, &Enum.sum/1)

  def eval({:product, _, _, values}), do: map_then(values, &Enum.product/1)

  def eval({:min, _, _, values}), do: map_then(values, &Enum.min/1)

  def eval({:max, _, _, values}), do: map_then(values, &Enum.max/1)

  def eval({:greater_than, _, _, [left, right]}), do: compare(left, right, &>/2)

  def eval({:less_than, _, _, [left, right]}), do: compare(left, right, &</2)

  def eval({:equal_to, _, _, [left, right]}), do: compare(left, right, &==/2)

  defp map_then(values, fun) do
    values
    |> Enum.map(&eval/1)
    |> then(fun)
  end

  defp compare(left, right, fun) do
    if fun.(eval(left), eval(right)), do: 1, else: 0
  end
end
