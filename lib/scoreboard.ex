defmodule Scoreboard do
  @moduledoc """
  Documentation for Scoreboard.
  """

  use GenServer

  # Client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  @doc """
  update user score.

  ## Examples
      iex> Scoreboard.push(pid, {"king" => 100})
      [{:hello, 1}, {"king", 100}]
  """
  def push(pid, {user, score}) do
    GenServer.call(pid, {:push, %{user => score}})
  end

  @doc """
  get user score.

  ## Examples
      iex> Scoreboard.get(pid, "king"})
      100
  """
  def get(pid, user) do
    GenServer.call(pid, {:get, user})
  end

  @doc """
  delete user score record from state.

  ## Examples
      iex> Scoreboard.del(pid, "king"})
      [{:hello, 1}]
  """
  def del(pid, user) do
    GenServer.call(pid, {:del, user})
  end

  @doc """
  get top 10 users score record from state.

  ## Examples
      iex> Scoreboard.top(pid})
      [{"king", 100}, {:hello, 1}]
  """
  def top(pid) do
    GenServer.call(pid, :top)
  end

  def clear(pid) do
    GenServer.call(pid, :clear)
  end

  # Server (callbacks)

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call({:get, user}, _from, state) do
    if Map.has_key?(state, user) do
      {:reply, Map.fetch!(state, user), state}
    else
      {:reply, :notfound, state}
    end
  end

  @impl true
  def handle_call({:push, element}, _from, state) do
    state = Map.merge(state, element, fn _k, v1, v2 -> v1 + v2 end)
    {:reply, Map.to_list(state), state}
  end

  @impl true
  def handle_call({:del, user}, _from, state) do
    state = Map.delete(state, user)
    {:reply, Map.to_list(state), state}
  end

  @impl true
  def handle_call(:top, _from, state) do
    top = Map.to_list(state)
    |> List.keysort(1)
    |> Enum.reverse
    |> Enum.take(10)
    {:reply, top, state}
  end

  @impl true
  def handle_call(:clear, _from, _state) do
    {:reply, :ok, %{}}
  end

end

#:sys.statistics(pid, true)
#:sys.trace(pid, true)
#:sys.get_state(pid)
#:sys.get_status(pid)

#{:ok, pid} = GenServer.start_link(Scoreboard, %{:hello => 1})
#Scoreboard.push(pid, {"king", 100})
#Scoreboard.push(pid, {"king", 100})
#Scoreboard.push(pid, {"king1", 100})
#Scoreboard.push(pid, {"king2", 100})
#Scoreboard.push(pid, {"king3", 100})
#Scoreboard.push(pid, {"king4", 100})
#Scoreboard.push(pid, {"knight", 100})
#Scoreboard.get(pid, :king)
#Scoreboard.del(pid, :king)
#Scoreboard.top(pid)
#Scoreboard.clear(pid)
