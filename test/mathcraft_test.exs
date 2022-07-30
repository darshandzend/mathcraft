defmodule MathcraftTest do
  use ExUnit.Case
  doctest Mathcraft

  test "greets the world" do
    assert Mathcraft.hello() == :world
  end
end
