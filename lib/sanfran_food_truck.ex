defmodule SanfranFoodTruck do
  alias SanfranFoodTruck.LocationValidator
  @moduledoc """
  Documentation for `SanfranFoodTruck`.
  """

  @doc """
  convert csv data to list of maps that have data of interest
  - latitude
  - longitude
  - address
  - food items
  - status (the current, expired, or pending col)
  - facility type (ie push cart or truck)

  ## Examples

      SanfranFoodTruck.get_data()
      [
        %{
            latitude: _,
            longitude: _,
            address: _,
            food_items: _,
            status: _,
            facility_type: _,
        } | _
      ]

  """
  def get_data(params \\ %{})
  def get_data(params) do
    File.stream!("Mobile_Food_Facility_Permit.csv")
    |> Stream.map(&(&1))
    |> CSV.decode!(headers: true)
    |> Enum.take_while(& !is_nil(&1))
    |> Enum.map(& LocationValidator.validate_and_normalize_location(&1))
    |> Enum.filter(& &1.status != :expired || params["get_expired"])
    |> maybe_order_locations(params)
    |> maybe_order_foods(params)
  end

  defp maybe_order_locations(list, %{"latitude" => latitude, "longitude" => longitude} = params) when is_binary(latitude) and is_binary(longitude) do
    maybe_order_locations(
      list,
      Map.merge(
        params,
        %{"latitude" => String.to_float(latitude), "longitude" => String.to_float(longitude)}
      )
    )
  end
  defp maybe_order_locations(list, %{"latitude" => latitude, "longitude" => longitude} = params) do
    if params["distance"] do
      list
      |> Enum.filter(& String.to_float(params["distance"]) >= calculate_distance(&1, %{latitude: latitude, longitude: longitude}, params["units"] || "miles" ) )
    else
      list
    end
    |> Enum.sort_by(&calculate_distance(&1, %{latitude: (latitude), longitude: (longitude)}, params["units"] || "miles" ), :asc)
  end
  defp maybe_order_locations(list, _params), do: list

  defp maybe_order_foods(list, %{"food_items" => food_items}) do
    list
    |> Enum.sort_by(& String.bag_distance(&1.food_items, food_items))
  end
  defp maybe_order_foods(list, _params), do: list

  def calculate_distance(%{latitude: lat_1, longitude: lon_1} = _p1, %{latitude: lat_2, longitude: lon_2} = _p2, units \\ "miles") when is_float(lat_1) and is_float(lon_1) and is_float(lat_2) and is_float(lon_2) and units in ["kilometers", "miles"] do
    import Math

    # Radius of the earth
    r = case units do
      "miles" -> 3958.756
      "kilometers" -> 6371
    end

    # Convert to radians
    lat_1 = (lat_1 * Math.pi())/180
    lat_2 = (lat_2 * Math.pi())/180
    lon_1 = (lon_1 * Math.pi())/180
    lon_2 = (lon_2 * Math.pi())/180

    # Haversine formula for distance
    2 * r * asin(
      sqrt(
        sin(
          (lat_2-lat_1)/2
        ) *
        sin(
          (lat_2-lat_1)/2
        ) +
        cos(lat_1) *
        cos(lat_2) *
        sin(
          (lon_2-lon_1)/2
        ) *
        sin(
          (lon_2-lon_1)/2
        )
      )
    )
  end
end
