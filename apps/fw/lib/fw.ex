defmodule Fw do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Task, [fn -> setup_network() end], restart: :transient)
    ]

    opts = [strategy: :one_for_one, name: Fw.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def setup_network do
    Nerves.InterimWiFi.setup "wlan0", ssid: "CITI", key_mgmt: :"WPA-PSK", psk: "1cbe991a14"
  end
end
