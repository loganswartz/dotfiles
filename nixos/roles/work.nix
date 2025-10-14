{ pkgs, config, ... }:

{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = builtins.attrNames config.users.users;
  };

  environment.systemPackages = with pkgs; [
    dbeaver-bin
    gimp-with-plugins
    gparted
    kdePackages.kcachegrind
    libreoffice
    networkmanager-openvpn
    (php.buildEnv { extraConfig = "memory_limit = 2G;"; })
    php84Packages.composer
    slack
  ];
}
