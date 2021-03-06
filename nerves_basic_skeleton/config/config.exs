use Mix.Config

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

config :shoehorn,
  init: [:nerves_runtime],
  app: Mix.Project.config()[:app]

config :logger, backends: [RingLogger]

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(Path.join(System.user_home!, ".ssh/id_rsa.pub"))
  ]

config :nerves_basic_skeleton, interface: :wlan0, port: 4001

config :nerves_init_gadget,
  node_name: :base_target,
  mdns_domain: "nerves_base.local",
  address_method: :dhcp,
  ifname: "wlan0"

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]

config :ui, UiWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 80],
  secret_key_base: "ZzL36EhVtO84rW4daeMWdXqodXkG63p02LpKms5selr8BgK4ud4N42B0YuOUx+LX",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: UiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false

config :logger, level: :debug
