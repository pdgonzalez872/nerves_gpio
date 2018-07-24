defmodule InBetweenTest do
  use ExUnit.Case
  doctest InBetween

  test "greets the world" do
    assert InBetween.hello() == :world
  end
end
