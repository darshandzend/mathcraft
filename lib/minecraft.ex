defmodule Minecraft do
  @moduledoc """
  Client for executing Minecraft commands.
  This is achieved through:
  1. Compiling a list of individual minecraft commands
  2. Putting that list in .mcfunction file
  3. Copying that file onto the designated directory in server
  4. Sending `reload` and `function` commands to the server
  """

  # TODO: support remote server
  @server_path "minecraft_server/world"
  @target_path "datapacks/mathcraft/data/custom/functions/"

  @source_dir "tmp/"
  @source_path "mathcraft.mcfunction"

  def fill(layers, substance) do
    layers
    |> coordinates
    |> mcfunction(substance)
    |> send_to_minecraft
  end

  @doc """
  Takes a list of layers and transforms them into {x, y, z} 
  coordinates. The order of layers in the list implicitely 
  indicates the z index, i.e. the first in list has z index of 0,
  the second layer has index of 1, and so on.
  ##Example:
  iex> layers = 
  iex> [
  iex>   %{0 => [1, 2, 3], 1 => [3, 4], 3 => [3, 4]},
  iex>   %{0 => [1, 3],    1 => [3, 4]             },
  iex>   %{}, # Empty layer
  iex>   %{1 => [9]}
  iex> ]
  iex> Minecraft.coordinates(layers)
  [{1,0,0}, {2,0,0}, {3,0,0}, {3,1,0}, {4,1,0}, {3,3,0}, {4,3,0},
    {1,0,1}, {3,0,1}, {3,1,1}, {4,1,1}, {9,1,3}]
  """
  def coordinates(layers) do
    layers
    |> Enum.with_index()
    |> Enum.flat_map(fn {layer, z} ->
      Enum.flat_map(layer, fn {y, exes} ->
        exes |> Enum.map(fn x -> {x, y, z} end)
      end)
    end)
  end

  @doc """
  Takes a list of {x,y,z} coordinates and transforms them into
  minecraft's 'setblock' command. These commands are written
  to a minecraft '.mcfunction' file.
  """
  def mcfunction(coords, substance) do
    # TODO: create a uuid file
    filename = @source_path
    file_path = Path.join(@source_dir, filename)
    file = File.open!(file_path, [:write, :utf8])

    coords
    |> Enum.each(fn {x, y, z} ->
      IO.puts(file, ~s"setblock #{x} #{z} #{y} #{substance}")
    end)

    File.close(file)

    filename
  end

  @doc """
  Takes a minecraft .mcfunction file an sends them to minecraft 
  server to be executed.
  """
  def send_to_minecraft(filename) do
    src = Path.join([@source_dir, filename])
    dest = Path.join([@server_path, @target_path, filename])
    File.copy!(src, dest)

    send_cmd_to_mc_server("reload")
    send_cmd_to_mc_server("function custom:mathcraft")
  end

  def send_cmd_to_mc_server(cmd) do
    :timer.sleep(1000)
    System.cmd("screen", ~w(-S minecraft -X stuff) ++ [cmd <> "\n"])
  end
end
