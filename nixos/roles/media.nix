{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    plex-desktop
    plexamp
  ];
}
