{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # networking tools
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    dnsutils  # `dig` + `nslookup`
    ethtool
    iftop # network monitoring
    iperf3
    nmap # A utility for network discovery and security auditing
    socat # replacement of openbsd-netcat
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
    openFirewall = true;
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # Solaar
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
}
