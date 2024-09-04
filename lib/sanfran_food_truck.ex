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
  def get_data() do
    File.stream!("Mobile_Food_Facility_Permit.csv")
    |> Stream.map(&(&1))
    |> CSV.decode!(headers: true)
    |> Enum.take_while(& !is_nil(&1))
    |> Enum.map(& LocationValidator.validate_and_normalize_location(&1))
  end
end
