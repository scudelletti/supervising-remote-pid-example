defmodule Blue.File do
  use GenServer

  require Logger

  def start_link(options \\ [name: {:global, __MODULE__}]) do
    case GenServer.start_link(__MODULE__, :ok, options) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        true = Process.link(pid)
        {:ok, pid}

      error ->
        error
    end
  end

  def write(filename) do
    GenServer.call({:global, __MODULE__}, {:filename, filename})
  end

  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, nil}
  end

  def handle_call({:filename, filename}, _from, state) do
    File.write("tmp/#{filename}-#{node()}", "")

    {:reply, :ok, state}
  end

  def handle_info({:EXIT, from, reason}, state) when node(from) != node() do
    Logger.info("Ignoring exit request since request is from different node")

    {:noreply, state}
  end
end
