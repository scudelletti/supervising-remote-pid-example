defmodule Blue.File do
  use GenServer

  require Logger

  def start_link(options \\ [name: {:global, __MODULE__}]) do
    GenServer.start_link(__MODULE__, :ok, options)
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

  def handle_info({:EXIT, from, _reason}, state) when node(from) != node() do
    Logger.info(
      "Ignoring exit request(#{inspect(from)}) since request is from different node(#{node()})"
    )

    {:noreply, state}
  end
end
