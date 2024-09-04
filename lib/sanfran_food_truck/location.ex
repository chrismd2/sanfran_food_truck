defmodule SanfranFoodTruck.Location do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :latitude, :float
    field :longitude, :float
    field :address, :string
    field :food_items, :string
    field :status, Ecto.Enum, values: [:current , :expired, :pending]
    field :facility_type, Ecto.Enum, values: [:push_cart , :truck]
  end

  @doc """
  Returns a changeset for changing the location data.

  ## Parameters
    - location: The location struct.
    - params: The parameters to validate and apply.

  ## Returns
    - An Ecto.Changeset struct.
  """
  def changeset(location, params \\ %{}) do
    location
    |> cast(params, [:latitude, :longitude, :address, :food_items, :status, :facility_type])
    |> validate_required([:latitude, :longitude, :address, :food_items, :status, :facility_type])
    |> validate_number(:latitude, greater_than: -90, less_than: 90)
    |> validate_number(:longitude, greater_than: -180, less_than: 180)
    |> validate_inclusion(:status, [:current, :expired, :pending])
    |> validate_inclusion(:facility_type, [:push_cart, :truck])
  end
end
