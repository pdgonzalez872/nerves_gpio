defmodule NervesWpaSupplicant.Mixfile do
  use Mix.Project

  def project do
    [app: :nerves_wpa_supplicant,
     version: "0.3.2",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:elixir_make] ++ Mix.compilers,
     make_clean: ["clean"],
     deps: deps(),
      docs: [extras: ["README.md"]],
     package: package(),
     description: description()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger],
     mod: {Nerves.WpaSupplicant.Application, []}]
  end

  defp description do
    """
    Elixir interface to the wpa_supplicant daemon. The wpa_supplicant
    provides application support for scanning for access points, managing
    Wi-Fi connections, and handling all of the security and other parameters
    associated with Wi-Fi.
    """
  end

  defp package do
    %{files: ["lib", "src/*.[ch]", "src/wpa_ctrl/*.[ch]", "test", "mix.exs", "README.md", "LICENSE", "CHANGELOG.md", "Makefile"],
      maintainers: ["Frank Hunleth", "Justin Schneck"],
      licenses: ["Apache-2.0", "BSD-3c"],
      links: %{"GitHub" => "https://github.com/nerves-project/nerves_wpa_supplicant"}}
  end

  defp deps do
    [{:elixir_make, "~> 0.3", runtime: false},
     {:ex_doc, "~> 0.11", only: :dev}]
  end
end
