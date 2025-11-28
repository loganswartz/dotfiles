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
    kdePackages.kcachegrind
    mariadb_114
    (php.buildEnv { extraConfig = "memory_limit = 2G;"; })
    php84Packages.composer
    slack
    usql
  ];
}
