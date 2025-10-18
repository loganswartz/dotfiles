{ nixos-hardware, pkgs, ... }:

{
  imports = [
    # closest comparable nixos-hardware preset
    # (these are grouped together in fwupdmgr)
    nixos-hardware.nixosModules.lenovo-thinkpad-p16s-amd-gen4

    # needs a newer kernel version for suspend to work properly
    # https://community.frame.work/t/framework-13-nixos-doesn-t-suspend/71715/2
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    }

    ../../peripherals/fingerprint-scanner.nix
  ];
}
