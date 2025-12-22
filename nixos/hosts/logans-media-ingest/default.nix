{ config, pkgs, lib, ... }:

{
  imports =
    [
      {
        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
      }
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../roles/media.nix
      ../../roles/media-ingest.nix
      ../../roles/gaming.nix
    ];
}
