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

      {
        # hyprlock frequently crashes on this machine for some reason, so better to disable for now
        config.home-manager.users.logans.services.hypridle.enable = false;
      }
      ../../hardware/machines/optiplex-5060
      ../../roles/media.nix
      ../../roles/gaming.nix
    ];
}
