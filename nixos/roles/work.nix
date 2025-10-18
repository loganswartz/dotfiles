{ pkgs, config, ... }:

{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = builtins.attrNames config.users.users;
  };

  networking.hosts = {
    "127.0.0.1" = [
      "terminal.local.stairsupplies.com"
      "terminal.local.viewrail.com"
      "vrd.local.stairsupplies.com"
      "vrd.local.viewrail.com"
    ];
  };

  environment.systemPackages = with pkgs; [
    dbeaver-bin
    gimp-with-plugins
    gparted
    kdePackages.kcachegrind
    libreoffice
    mariadb_114
    networkmanager-openvpn
    (php.buildEnv { extraConfig = "memory_limit = 2G;"; })
    php84Packages.composer
    slack
    usql
  ];
}
