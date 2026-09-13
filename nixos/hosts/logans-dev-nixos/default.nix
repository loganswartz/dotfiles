{ ... }:

{
  imports = [
    {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    }
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ({ config, lib, ... }: {
      # hyprlock frequently crashes on this machine for some reason, so better to disable for now
      home-manager.users =
        lib.genAttrs config.host.users (_: { services.hypridle.enable = false; });
    })
    ../../hardware/machines/optiplex-5060
    ../../roles/media.nix
    ../../roles/gaming.nix
  ];
}
