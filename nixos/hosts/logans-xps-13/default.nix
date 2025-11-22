{ ... }:

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

      ../../hardware/machines/xps-13-9360
      ../../roles/media.nix
      ../../roles/gaming.nix
      ../../roles/wireguard.nix
    ];
}
