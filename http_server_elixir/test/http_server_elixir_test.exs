defmodule HttpServerElixirTest do
  use ExUnit.Case
  doctest HttpServerElixir

  test "greets the world" do
    assert HttpServerElixir.hello() == :world
  end
end
