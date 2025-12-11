{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    moonlight
    obs-studio
  ];

  programs.steam.enable = true;
}
