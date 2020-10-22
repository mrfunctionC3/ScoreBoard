defmodule ScoreBoardTest do
  use ExUnit.Case
  doctest ScoreBoard

  setup do
    {:ok, pid} = ScoreBoard.start_link(%{:hello => 1})
    [pid: pid]
  end

  # test CRUD

  test "insert record", context do
    assert ScoreBoard.push(context.pid, {"king", 100}) == {"king", 100}
  end

  test "insert record value wrong format", context do
    assert ScoreBoard.push(context.pid, {"king", "a"}) == :error
  end

  test "read specific record", context do
    ScoreBoard.push(context.pid, {"king", 100})
    ScoreBoard.push(context.pid, {"knight", 80})
    ScoreBoard.push(context.pid, {"queen", 90})
    assert ScoreBoard.get(context.pid, "king") == 100
    assert ScoreBoard.get(context.pid, "queen") == 90
    assert ScoreBoard.get(context.pid, "knight") == 80
  end

  test "read specific record key not exist", context do
    ScoreBoard.push(context.pid, {"king", 100})
    ScoreBoard.push(context.pid, {"knight", 80})
    ScoreBoard.push(context.pid, {"queen", 90})
    assert ScoreBoard.get(context.pid, "pawn") == :notfound
  end

  test "update specific record", context do
    ScoreBoard.push(context.pid, {"king", 100})
    ScoreBoard.push(context.pid, {"knight", 80})
    ScoreBoard.push(context.pid, {"queen", 90})

    assert ScoreBoard.get(context.pid, "king") == 100
    ScoreBoard.push(context.pid, {"king", 50})
    assert ScoreBoard.get(context.pid, "king") == 150
  end

  test "update specific record - wrong format", context do
    ScoreBoard.push(context.pid, {"king", 100})
    ScoreBoard.push(context.pid, {"queen", 90})
    ScoreBoard.push(context.pid, {"knight", 80})

    ScoreBoard.push(context.pid, {"king", "1.1"})
    ScoreBoard.push(context.pid, {"queen", 3.1415926})
    ScoreBoard.push(context.pid, {"knight", "a"})
    assert ScoreBoard.get(context.pid, "king") == 100
    assert ScoreBoard.get(context.pid, "queen") == 90
    assert ScoreBoard.get(context.pid, "knight") == 80
  end

  test "delete specific record", context do
    ScoreBoard.push(context.pid, {"king", 100})
    ScoreBoard.push(context.pid, {"queen", 90})
    ScoreBoard.push(context.pid, {"knight", 80})

    assert ScoreBoard.del(context.pid, "king") == :ok
    assert ScoreBoard.get(context.pid, "king") == :notfound
    assert ScoreBoard.get(context.pid, "queen") == 90
    assert ScoreBoard.get(context.pid, "knight") == 80
  end

  test "delete specific record wrong key", context do
    ScoreBoard.push(context.pid, {"king", 100})
    ScoreBoard.push(context.pid, {"queen", 90})
    ScoreBoard.push(context.pid, {"knight", 80})

    assert ScoreBoard.del(context.pid, "king1") == :ok
    assert ScoreBoard.get(context.pid, "king") == 100
    assert ScoreBoard.get(context.pid, "queen") == 90
    assert ScoreBoard.get(context.pid, "knight") == 80
  end

  test "get top 10 users record", context do
    ScoreBoard.push(context.pid, {"king", 100})
    ScoreBoard.push(context.pid, {"queen", 90})
    ScoreBoard.push(context.pid, {"knight", 80})
    ScoreBoard.push(context.pid, {"user1", 1})
    ScoreBoard.push(context.pid, {"user2", 2})
    ScoreBoard.push(context.pid, {"user3", 3})
    ScoreBoard.push(context.pid, {"user4", 4})
    ScoreBoard.push(context.pid, {"user5", 5})
    ScoreBoard.push(context.pid, {"user6", 6})
    ScoreBoard.push(context.pid, {"user7", 7})
    ScoreBoard.push(context.pid, {"user8", 8})
    ScoreBoard.push(context.pid, {"user9", 9})
    ScoreBoard.push(context.pid, {"user10", 10})

    assert ScoreBoard.top(context.pid) == [
             {"king", 100},
             {"queen", 90},
             {"knight", 80},
             {"user10", 10},
             {"user9", 9},
             {"user8", 8},
             {"user7", 7},
             {"user6", 6},
             {"user5", 5},
             {"user4", 4}
           ]

    ScoreBoard.push(context.pid, {"user101", 101})
    assert ScoreBoard.top(context.pid) == [
             {"user101", 101},
             {"king", 100},
             {"queen", 90},
             {"knight", 80},
             {"user10", 10},
             {"user9", 9},
             {"user8", 8},
             {"user7", 7},
             {"user6", 6},
             {"user5", 5}
           ]
  end

  test "clear all users record", context do
    ScoreBoard.push(context.pid, {"king", 100})
    ScoreBoard.push(context.pid, {"queen", 90})
    ScoreBoard.push(context.pid, {"knight", 80})

    assert ScoreBoard.get(context.pid, "king") == 100
    assert ScoreBoard.get(context.pid, "queen") == 90
    assert ScoreBoard.get(context.pid, "knight") == 80

    assert ScoreBoard.clear(context.pid) == :ok
    assert ScoreBoard.get(context.pid, "king") == :notfound
    assert ScoreBoard.get(context.pid, "queen") == :notfound
    assert ScoreBoard.get(context.pid, "knight") == :notfound
  end

end
