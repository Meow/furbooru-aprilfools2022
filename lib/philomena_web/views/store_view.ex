defmodule PhilomenaWeb.StoreView do
  use PhilomenaWeb, :view

  def products do
    ["Hot Rod Paw", "Nature's Gift Paw", "Icy Paw", "Fairy Paw", "Energy Shock Paw", "SPECIAL FURBOORU PAW"]
    |> Enum.with_index()
    |> Enum.map(fn {name, idx} ->
      {"/images/product#{idx}.svg", name}
    end)
    |> Enum.shuffle()
  end

  def price do
    numbers = [0, 13, 34, 37, 42, 69, 420]

    "$#{Enum.random(numbers)}.#{Enum.random(numbers)}"
  end
end
