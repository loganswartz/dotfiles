{ ... }:

{
  imports =
    [
      {
        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        boot.initrd.luks.devices."luks-233ccd50-a727-43e2-8476-802f6f48bf9b".device = "/dev/disk/by-uuid/233ccd50-a727-43e2-8476-802f6f48bf9b";
      }

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../hardware/machines/thinkpad-t16-gen4

      ../../roles/work.nix
      ../../roles/media.nix
    ];
}
