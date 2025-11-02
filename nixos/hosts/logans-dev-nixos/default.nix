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

      ../../hardware/machines/optiplex-5060
      ../../roles/media.nix
      ../../roles/gaming.nix
    ];
}
