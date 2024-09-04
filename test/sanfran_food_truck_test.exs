defmodule SanfranFoodTruckTest do
  use ExUnit.Case
  doctest SanfranFoodTruck

  test "get data and check data shape" do
    assert [
      %{
          latitude: _,
          longitude: _,
          address: _,
          food_items: _,
          status: _,
          facility_type: _,
      } | _
    ] = SanfranFoodTruck.get_data()
  end
end
