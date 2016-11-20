# Hello Nerves

[Nerves Project](https://github.com/nerves-project)-based example used in my talk at the [elug_sp](https://www.meetup.com/elug_sp/) (São Paulo's Elixir User Group) meetup #7. It consists in a **phoenix app with a button to blink a led, everything running on a Rasperry Pi 3**.

![project overview](https://raw.githubusercontent.com/geonnave/hello-nerves/master/priv/project-overview.png)

A summary of all its features:

* toggle led on/off via gpio
* phoenix app providing *ui* for controlling the led
* *wifi*-enabled, via https://github.com/nerves-project/nerves_interim_wifi
* *firmware-over-the-air* updates available, via https://github.com/nerves-project/nerves_firmware_http
* vm.args configured with sample `name` and `cookie` for facilitating remote board debugging

# Running
Just run some pretty simple commands listed below. 

**Note 1**: you should have **Nerves** installled. Refer to the [official docs](https://hexdocs.pm/nerves/installation.html#content) to get it running.
**Note 2**: the positive wire of the LED goes on the **GPIO pin #26**. Check the Raspberry Pi 3 pinout [here](https://az835927.vo.msecnd.net/sites/iot/Resources/images/PinMappings/RP2_Pinout.png). The negative one goes to any **GND** (ground) pin.

#### Go to the `apps/fw` directory and install dependencies
```
cd apps/fw
mix deps.get
```

**Note 3**: everything from now on assume you are working from the `apps/fw` directory.

#### Change your WiFi credentials
Modify `lib/fw.ex` and change the `SSID` (the "name" of your network) and the password:
```
Nerves.InterimWiFi.setup "wlan0",
  key_mgmt: :"WPA-PSK",
  ssid: "PUT YOUR NETWORK NAME HERE",
  psk: "AND HERE YOUR SECRET PASSWORD"
```
If you have doubts, check the [nerves_interim_wifi](https://github.com/nerves-project/nerves_interim_wifi) README.

#### Generate and write the sd card image
```
mix firmware
mix firmware.burn
```

#### Just insert the sd card in the rpi3 and cross you fingers :D
<img src="https://media1.popsugar-assets.com/files/thumbor/Vn3epuKRUZLRsec6Ww1mzyOfJAA/fit-in/2048xorig/filters:format_auto-!!-:strip_icc-!!-/2014/07/28/909/n/1922507/740abf9ac5c2563e_fingers-crossed/i/Fingers-Crossed.jpg" alt="cross-fingers" width="100">

If the led light up, it worked.

**tip**: the easiest way to get to know your IP Address is to use an HDMI cable to connect the rpi3 to a monitor, and then watch the logs for the *dhcp* updates.

# Remote Update
POST the `_images/rpi3/fw.fw` file to `<board's ip>:8988/firmware'`. Example (using [httpie](https://httpie.org/)):
```
http POST 192.168.0.7:8988/firmware content-type:application/x-firmware x-reboot:true < _images/rpi3/fw.fw
```

# Remote shell & debugging

Firs of all, edit the `rel/vm.args` file and update it with the board's ip address in the line that says `-name`.

Then, run `mix firmware` again reflash the sd card.

#### `remsh` (or the Erlang's `ssh`)
As simple as this:
```
iex --name host1@192.168.0.6 --remsh raspi@192.168.0.7 --cookie secret
```
You will drop to the board's shell.

#### using `:observer`
```
iex --name host2@192.168.0.6 --cookie secret
```
You will drop to a normal iex shell. Then run `:observer.start`. A GUI interface will open. In that GUI, go to `Nodes`->`connect`. Insert the *name* of the node, i.e the string after `-name` option in the `rel/vm.args` file. If everything is correct, it should connect and you will be able to see the apps in the *Applications* tab.
