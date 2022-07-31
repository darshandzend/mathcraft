defmodule Frames do
  @moduledoc """
  A frame is a picture. That is, a 2D matrix, with rows and columns.
  Here it is represented by a Map:
  %{
    0 => [1, 3, 4, 5],
    1 => [3, 9],
    4 => [9, 10]
  }
  This translates to, "for row 0, fill columns 1, 3, 4, and 5" and so on
  """

  @doc """
  Converts a list of points expressed in {x,y} into a 2D frame.
  ## Example:
  iex> points = [{2,3}, {4,3}, {1, 2}, {3, 9}]
  iex> Frames.to_frame(points)
  %{2 => [1], 3 => [2, 4], 9 => [3]}
  """
  def to_frame(points) do
    Enum.group_by(
      points,
      # these will be the keys
      fn {_, y} -> y end,
      # these will values
      fn {x, _} -> x end
    )
  end

  @doc """
  Helpful function to visualise the blocks right in the console screen.
  Your terminal might not render 3D, so instead this function treats z axis
  as 'time axis' and shows you how the top-view cross section might look
  like, layer by layer. Also a nice function to just play around with.
  """
  def animate(frames, %{fps: framerate}, canvas_size = {_, _}) do
    Enum.each(frames, fn frame ->
      IEx.Helpers.clear()
      draw_frame(frame, canvas_size)
      :timer.sleep(round(1000/framerate))
    end)
  end

  def draw_frame(frame, {height, width}) do
    IO.write Enum.reverse(0..(height - 1))
    |> Enum.map(fn y -> next_line(frame[y], width) end)
  end

  @empty "  "
  @fill  "🟥"
  # Helpful website to browse unicode blocks:
  # https://unicode-search.net/unicode-namesearch.pl
  defp next_line(nil, width) do
    String.duplicate(@empty, width) <> "\n"
  end

  defp next_line(line, width) do
    list = Enum.map(0..(width-1), fn indx -> 
      if indx in line, do: @fill, else: @empty
    end)
    List.to_string(list) <> "\n"
  end

end
