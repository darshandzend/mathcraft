defmodule MinecraftTest do
  use ExUnit.Case
  doctest Minecraft

  @test_file "test/tmp/mathcraft.mcfunction"

  test "Check correctness of file produced by mcfunction" do
    coords = [{1, 0, 0}, {2, 3, 2}, {3, 2, 3}, {3, 1, 3}]
    mcfile = Minecraft.mcfunction(coords, "smooth_stone")

    expected = File.read!(@test_file)
    produced = File.read!(mcfile)

    assert produced === expected

    # Clean up file produced by mcfunction
    File.rm_rf(produced)
  end
end
