defmodule HttpServerElixirCowsayTest do
  use ExUnit.Case
  doctest HttpServerElixirCowsay

  test "greets the world" do
    assert HttpServerElixirCowsay.hello() == :world
  end
end
