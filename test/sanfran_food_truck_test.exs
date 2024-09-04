defmodule SanfranFoodTruckTest do
  use ExUnit.Case
  doctest SanfranFoodTruck

  test "greets the world" do
    assert SanfranFoodTruck.hello() == :world
  end
end
