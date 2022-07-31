defmodule Minecraft do
  @moduledoc """
  API client for sending out Minecraft commands
  """
  def plot_point(point={_,_,_}, substance) do
    fill(point, point, substance)
  end

  def fill({x1,y1,z1}, {x2,y2,z2}, substance) do
    cmd = ~s(fill #{x1} #{z1} #{y1} #{x2} #{z2} #{y2} #{substance})
    System.cmd("screen", ~w(-S minecraft -X stuff) ++ [cmd <> "\n"])
  end
end
