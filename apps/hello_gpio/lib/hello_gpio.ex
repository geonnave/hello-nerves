defmodule HelloGpio do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(HelloGpio.Blinky, []),
    ]

    opts = [strategy: :one_for_one, name: HelloGpio.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule HelloGpio.Blinky do
  use GenServer
  require Logger

  @ledpin 26

  def start_link do
    GenServer.start_link __MODULE__, [], name: __MODULE__
  end

  def on, do: GenServer.cast(__MODULE__, :on)
  def off, do: GenServer.cast(__MODULE__, :off)

  def init(_) do
    Logger.debug "Initializing.."
    {:ok, pin} = Gpio.start_link(@ledpin, :output)
    Gpio.write(pin, 1)
    {:ok, pin}
  end

  def handle_cast(:on, pin) do
    Logger.debug "writing 1 to ledpin #{inspect pin}"
    Gpio.write(pin, 1)
    {:noreply, pin}
  end

  def handle_cast(:off, pin) do
    Logger.debug "writing 0 to ledpin #{inspect pin}"
    Gpio.write(pin, 0)
    {:noreply, pin}
  end
end
