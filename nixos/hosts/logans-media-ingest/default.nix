{ config, pkgs, lib, ... }:

{
  imports = [
    {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelParams = [ "video=DP-5:panel_orientation=left_side_up" ];
    }
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    {
      # hyprlock putting the machine to sleep is annoying, so disable it here
      config.home-manager.users.logans.services.hypridle.enable = false;
    }
    ../../roles/media.nix
    ../../roles/media-ingest.nix
    ../../roles/gaming.nix
  ];
}
