defmodule ScoreBoardTest do
  use ExUnit.Case
  doctest ScoreBoard

  test "greets the world" do
    assert ScoreBoard.push() == :world
  end
end
