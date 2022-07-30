defmodule Example do
  @canvas_size {41, 41}
  @center {20, 20}
  def circles do
    radii = Enum.to_list(0..15) 
            ++ Enum.to_list(14..0)
            ++ Enum.to_list(0..15) 
    frames = Enum.map(radii, fn z ->
        Circle.get(z)
        |> Points.pixelate()
        |> Points.move_and_clip(@center, @canvas_size)
        |> Frames.to_frame()
      end)

    Frames.animate(frames, %{fps: 10}, @canvas_size)
  end
end
