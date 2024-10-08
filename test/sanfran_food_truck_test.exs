defmodule SanfranFoodTruckTest do
  use ExUnit.Case
  doctest SanfranFoodTruck
  alias SanfranFoodTruck.{LocationValidator}

  test "check location validator shape" do
    [data] = File.stream!("Mobile_Food_Facility_Permit.csv")
      |> Stream.map(&(&1))
      |> CSV.decode!(headers: true)
      |> Enum.take(1)

    assert %{
      latitude: _latitude,
      longitude: _longitude,
      address: _address,
      food_items: _,
      status: _status,
      facility_type: _,
    } = data
    |> LocationValidator.validate_and_normalize_location
  end

  test "get data and check data shape" do
    SanfranFoodTruck.get_data()
    |> Enum.each(fn location ->
      assert %{
        latitude: _,
        longitude: _,
        address: _,
        food_items: _,
        status: _,
        facility_type: _,
      } = location
    end)
  end

  test "ensure no locations are expired" do
    SanfranFoodTruck.get_data()
    |> Enum.each(fn %{status: status} ->
      assert status in ~w(current pending)a
    end)
  end

  test "test distance of locations" do
    distance = 2
    latitude = 37.78583
    longitude = -122.4064
    results = SanfranFoodTruck.get_data(%{"distance" => to_string(distance), "latitude" => to_string(latitude), "longitude" => to_string(longitude)})
    results
    |> Enum.each(fn location ->
      assert SanfranFoodTruck.calculate_distance(%{latitude: latitude, longitude: longitude}, location) <= distance
    end)

    first = results |> List.first()
    last = results |> List.last()
    assert SanfranFoodTruck.calculate_distance(%{latitude: latitude, longitude: longitude}, first) <= SanfranFoodTruck.calculate_distance(%{latitude: latitude, longitude: longitude}, last)
  end

  test "order by food similarity" do
    assert SanfranFoodTruck.get_data(%{"food_items" => "rice"})
    |> List.first()
    |> Map.get(:food_items)
    |> String.contains?("rice")
  end
end
