{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    steam
    obs-studio
  ];
}
