# WireGuard VPN client role, managed by NetworkManager
{ pkgs, ... }:

{
  # https://wiki.nixos.org/wiki/WireGuard#NetworkManager_Proxy_client_setup
  networking.firewall.checkReversePath = "loose";

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  # configure your wireguard connection in a file called vpn.conf and import it into NetworkManager with:
  # $ nmcli connection import type wireguard file vpn.conf

  # example vpn.conf:

  # [Interface]
  # # your own (client) IP on the wireguard network
  # Address = 10.10.0.X/32
  # Table = auto
  # # your private key
  # PrivateKey = 00000000000000000000000000000000000000000000
  #
  # [Peer]
  # # public key of the peer you are connecting to (the server)
  # PublicKey = 11111111111111111111111111111111111111111111
  # # restrict this to the wireguard subnet if you don't want to route everything to the tunnel
  # AllowedIPs = 0.0.0.0/0, ::/0
  # # ip and port of the peer
  # Endpoint = some.host.name:51820

  # If your wireguard peer is also a DNS server for your remote domain, you may
  # want to set the first DNS server for the connection in NetworkManager to
  # that upstream IP (ex: 10.10.0.1). That way, you can access your remote
  # resources by hostname as you normally would when you're actually on the
  # network.
}
