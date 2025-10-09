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
      ../../machines/xps-13-9360
      ../../roles/gaming.nix
    ];
}
