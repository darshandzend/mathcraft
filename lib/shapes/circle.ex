defmodule Circle do
  import :math, only: [sqrt: 1, sin: 1, cos: 1]

  def get(r), do: radial(r)

  def radial(r) do
    Enum.map(0..360, fn θ -> {r * cos(θ), r * sin(θ)} end)
  end

  def raster(r) do
    Enum.map(0..r, fn x -> {x, sqrt(r ** 2 - x ** 2)} end)
    |> Enum.flat_map(fn {x, y} ->
      [{x, y}, {x, -y}, {-x, y}, {-x, -y}]
    end)
  end
end
