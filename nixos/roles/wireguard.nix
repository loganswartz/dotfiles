{ pkgs, ... }:

{
  # https://wiki.nixos.org/wiki/WireGuard#NetworkManager_Proxy_client_setup
  networking.firewall.checkReversePath = "loose";
  # then do:
  # nmcli connection import type wireguard file thefile.conf

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
