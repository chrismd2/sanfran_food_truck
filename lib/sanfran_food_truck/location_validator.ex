defmodule SanfranFoodTruck.LocationValidator do
  import Ecto.Changeset
  alias SanfranFoodTruck.Location

  @doc """
  Validates and normalizes location data from user input.

  ## Parameters
    - params: A map containing the user input to validate and normalize.

  ## Returns
    - {:ok, changeset} if validation passes, where changeset is a map of normalized data.
    - {:error, changeset} if validation fails, where changeset contains error details.
  """
  def validate_and_normalize_location(params) do
    %Location{}
    |> cast(params, [:latitude, :longitude, :address, :food_items, :status, :facility_type])
    |> validate_inclusion(:status, [:current, :expired, :pending])
    |> validate_inclusion(:facility_type, [:push_cart, :truck])
    |> put_change(:latitude, String.to_float(params["Latitude"]))
    |> put_change(:longitude, String.to_float(params["Longitude"]))
    |> validate_number(:latitude, greater_than: -90, less_than: 90)
    |> validate_number(:longitude, greater_than: -180, less_than: 180)
    |> put_change(:address, String.upcase(params["Address"]))
    |> put_change(:food_items, normalize_food_items(params["FoodItems"]))
    |> put_change(:status, normalize_status(params["Status"]))
    |> put_change(:facility_type, normalize_facility_type(params["FacilityType"]))
    |> validate_required([:latitude, :longitude, :address, :food_items, :status, :facility_type])
    |> apply_action(:validate)
  end

  defp normalize_food_items(items) when is_binary(items) do
    items
    |> String.downcase()
    |> String.replace(~r/:/, ", ")
    |> String.trim()
  end

  defp normalize_status(status) do
    case status do
      "APPROVED" -> :current
      "PENDING" -> :pending
      _ -> :expired
    end
  end

  defp normalize_facility_type(type) do
    case String.downcase(type) do
      "truck" -> :truck
      _ -> :push_cart
    end
  end
end