defmodule ScoreBoard do
  @moduledoc """
  score board system
  """

  use GenServer

  # Client

  def start_link(default) when is_map(default) do
    GenServer.start_link(__MODULE__, default)
  end

  @doc """
  update user score.

  ## Examples
      iex> {:ok, pid} = ScoreBoard.start_link(%{:hello => 1})
      iex> ScoreBoard.push(pid, {"king", 100})
      {"king", 100}
  """
  def push(pid, {user, score}) do
    if is_integer(score) do
      GenServer.call(pid, {:push, {user, score}})
    else
      :error
    end
  end

  @doc """
  get user score.

  ## Examples
      iex> {:ok, pid} = ScoreBoard.start_link(%{"king" => 100})
      iex> ScoreBoard.get(pid, "king")
      100
  """
  def get(pid, user) do
    GenServer.call(pid, {:get, user})
  end

  @doc """
  delete user score record from state.

  ## Examples
      iex> {:ok, pid} = ScoreBoard.start_link(%{:hello => 1})
      iex> ScoreBoard.del(pid, "king")
      :ok
  """
  def del(pid, user) do
    GenServer.call(pid, {:del, user})
  end

  @doc """
  get top 10 users score record from state.

  ## Examples
      iex> {:ok, pid} = ScoreBoard.start_link(%{:hello => 1})
      iex> ScoreBoard.push(pid, {"king", 100})
      iex> ScoreBoard.push(pid, {"knight", 80})
      iex> ScoreBoard.top(pid)
      [{"king", 100}, {"knight", 80}, {:hello, 1}]
  """
  def top(pid) do
    GenServer.call(pid, :top)
  end

  @doc """
  clear users score record from state.

  ## Examples
      iex> {:ok, pid} = ScoreBoard.start_link(%{:hello => 1})
      iex> ScoreBoard.push(pid, {"king", 100})
      iex> ScoreBoard.clear(pid)
      :ok
  """
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
  def handle_call({:push, {user, score}}, _from, state) do
    element = %{user => score}
    state = Map.merge(state, element, fn _k, v1, v2 -> v1 + v2 end)
    {:reply, {user, Map.fetch!(state, user)}, state}
  end

  @impl true
  def handle_call({:del, user}, _from, state) do
    state = Map.delete(state, user)
    {:reply, :ok, state}
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
