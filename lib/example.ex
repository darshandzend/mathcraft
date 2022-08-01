defmodule Example do
  @moduledoc """
  "Demo" functions to show how the interface can be used.
  """
  @canvas_size {41, 41}
  @center {0, 0}
  #@substance "minecraft:magenta_terracotta"
  @substance "minecraft:magenta_terracotta"
  def circles do
    cylinder = Enum.map(Enum.to_list(0..40), fn _ ->
      Circle.get(15)
      |> Points.pixelate()
      |> Points.move_and_clip(@center, @canvas_size)
      |> Layers.to_layer()
    end)
    Minecraft.fill(cylinder, @substance)
    dome = Enum.map(Enum.to_list(41..55), fn z ->
      radius_at(z-40)
      |> Circle.get
      |> Points.pixelate()
      |> Points.move_and_clip(@center, @canvas_size)
      |> Layers.to_layer()
    end)
    moved_up_dome = Enum.map(
      Enum.to_list(0..40), fn _ -> %{} end)
      ++ dome
  end

  def radius_at(z) do
    abs(:math.sqrt(15 ** 2 - z ** 2))
  end
end
