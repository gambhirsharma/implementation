defmodule MpvCliTest do
  use ExUnit.Case
  doctest MpvCli

  test "greets the world" do
    assert MpvCli.hello() == :world
  end
end
