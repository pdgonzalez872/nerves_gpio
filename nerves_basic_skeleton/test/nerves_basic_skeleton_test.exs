defmodule NervesBasicSkeletonTest do
  use ExUnit.Case
  doctest NervesBasicSkeleton

  test "greets the world" do
    assert NervesBasicSkeleton.hello() == :world
  end
end
