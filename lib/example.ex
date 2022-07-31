defmodule Example do
  @moduledoc """
  "Demo" functions to show how the interface can be used.
  """
  @canvas_size {41, 41}
  @center {20, 20}
  def circles do
    z_range = Enum.to_list(15..0) ++ Enum.to_list(1..15)
    frames = Enum.map(z_range, fn z ->
        Circle.get(z)
        |> Points.pixelate()
        |> Points.move_and_clip(@center, @canvas_size)
        |> Frames.to_frame()
      end)

    Frames.animate(frames, %{fps: 10}, @canvas_size)
  end
end
