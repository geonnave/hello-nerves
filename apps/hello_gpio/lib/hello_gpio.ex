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

  def toggle, do: GenServer.cast(__MODULE__, :toggle)

  def init(_) do
    Logger.debug "Initializing.."
    {:ok, pin} = Gpio.start_link(@ledpin, :output)
    Gpio.write(pin, 1)
    {:ok, {pin, 1}}
  end

  def handle_cast(:toggle, {pin, pin_state}) do
    new_pin_state = if pin_state == 0, do: 1, else: 0
    Logger.debug "writing #{new_pin_state} to ledpin #{inspect pin}"
    Gpio.write(pin, new_pin_state)
    {:noreply, {pin, new_pin_state}}
  end
end
