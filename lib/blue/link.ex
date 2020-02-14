defmodule Blue.Link do
  use GenServer

  require Logger

  def start_link(options \\ [name: {:global, __MODULE__}]) do
    GenServer.start_link(__MODULE__, :ok, options)
  end

  @impl true
  def init(_) do
    {:ok, nil, {:continue, :initialize}}
  end

  @impl true
  def handle_continue(:initialize, _state) do
    state =
      case Blue.File.start_link() do
        {:ok, pid} ->
          {:local, pid}

        {:error, {:already_started, pid}} ->
          true = Process.link(pid)
          {:remote, pid}
      end

    {:noreply, state}
  end

  @impl true
  def terminate(_reason, state) do
    Logger.warn("UNLINK############")
    cleanup(state)

    IO.puts("Going Down: #{inspect(state)}")
    :normal
  end

  def cleanup({:local, _pid}), do: nil

  def cleanup({:remote, pid}) do
    Process.unlink(pid)
  end
end
