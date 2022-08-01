defmodule Points do
  import Enum, only: [map: 2]

  @moduledoc """
  Provides the fandamental 2D point struct and transformation functions.
  A point is a 2 element tuple: {x, y}.
  """
  # ----- Public API -----------------------------------------------------
  @doc """
  Convert continuous {x,y} into pixels
  ## Example
  iex> points = [{2.7,2.9}, {3.1352342,3.3322}]
  iex> Points.pixelate(points)
  [{3,3}, {3,3}]
  """
  def pixelate(points) when is_list(points) do
    map(points, &pixelate(&1))
  end

  def pixelate(point = {_, _}) do
    transform(point, &round/1)
  end

  @doc """
  To move points in 2D space, by a given shift.
  Same as performing shift-of-origin.
  ## Example
  iex> points = [{2,2}, {3,3}]
  iex> Points.move(points, {2,2})
  [{4,4}, {5,5}]
  """
  def move(points, shift) when is_list(points) do
    map(points, &move(&1, shift))
  end

  def move(point = {_, _}, shift = {_, _}) do
    transform(point, shift, &add/2)
  end

  @doc """
  To prevent points from crossing beyond a given maximum point.
  ## Example
  iex> points = [{2,2}, {11,11}]
  iex> Points.clip(points, {10,10})
  [{2,2}, {10,10}]
  """
  def clip(points, max_point) when is_list(points) do
    map(points, &clip(&1, max_point))
  end

  def clip(point = {_, _}, max_point = {_, _}) do
    transform(point, max_point, &min/2)
  end

  @doc """
  Conveniance function for performing both move and clip in one go.
  ## Example
  iex> points = [{2,2}, {39,39}]
  iex> shift  = {2,2}
  iex> clip   = {40,40}
  iex> Points.move_and_clip(points, shift, clip)
  [{4,4}, {40,40}]
  """
  def move_and_clip(points, shift, max_point) when is_list(points) do
    map(points, &move_and_clip(&1, shift, max_point))
  end

  def move_and_clip(point = {_, _}, shift = {_, _}, max_point = {_, _}) do
    point |> move(shift) |> clip(max_point)
  end

  # ----- Internal functions ---------------------------------------------
  defp transform({x, y}, operation) do
    {
      operation.(x),
      operation.(y)
    }
  end

  defp transform({x, y}, {ref_x, ref_y}, operation) do
    {
      operation.(x, ref_x),
      operation.(y, ref_y)
    }
  end

  defp add(a, b), do: a + b
end
