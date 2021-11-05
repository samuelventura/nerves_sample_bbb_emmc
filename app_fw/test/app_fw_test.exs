defmodule AppFwTest do
  use ExUnit.Case
  doctest AppFw

  test "greets the world" do
    assert AppFw.hello() == :world
  end
end
