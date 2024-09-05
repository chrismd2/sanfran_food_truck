# SanfranFoodTruck

This project interacts with data provided by San Fransisco liscensing agency for food trucks to filter and return data of interest based on food types, close to a latitude & longitude, and within a certain distance.

## Installation

Add this project to the local directory (ie `git clone https://github.com/chrismd2/sanfran_food_truck.git`) and the package can be installed
by adding `sanfran_food_truck` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sanfran_food_truck, "~> 0.1.0", path: "./sanfran_food_truck"}
  ]
end
```

## Postman info
Use this url:
```
https://electricquestlog.com/api/sanfran_food_truck?latitude=37.738726803987134&longitude=-122.40673602990493&distance=0.25&food_items=tacos, burritos, quesadillas, tortas, nachos (refried beans, cheese sauce, salsa fresca), carnes (beef, chicken, marinated pork, fried pork), canned beans, rice, sodas, horchata drinks.&include_push_carts=true
```

Add this command to the scripts tab:
```
console.log(JSON.parse(pm.response.json().results))
```
