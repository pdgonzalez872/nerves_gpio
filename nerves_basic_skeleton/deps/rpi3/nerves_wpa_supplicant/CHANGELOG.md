# Changelog

## v0.3.2
  * Enhancements
    * Fix deprecation warnings for Elixir 1.5

## v0.3.1

  * Enhancements
    * Support compilation on OSX. It won't work, but it's good enough for
      generating docs and pushing to hex.

  * Bug fixes
    * Fixed a couple bugs when scanning for WiFi networks

## v0.3.0

  * Enhancements
    * Replaced GenEvent with Registry

## v0.2.3

  * Bug fixes
    * Clean up warnings for Elixir 1.4

## v0.2.2

  * Bug fixes
    * Invalid network settings would crash `set_network`. Now they
      return errors, since some can originate with bad user input.
      E.g., a short password

## v0.2.1

  * Bug fixes
    * Fixes from integrating with nerves_interim_wifi

## v0.2.0

Renamed from `wpa_supplicant.ex` to `nerves_wpa_supplicant``
