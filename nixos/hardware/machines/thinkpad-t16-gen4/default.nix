{ nixos-hardware, pkgs, ... }:

{
  imports = [
    # closest comparable nixos-hardware preset
    nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen5

    # needs a newer kernel version for suspend to work properly
    # https://community.frame.work/t/framework-13-nixos-doesn-t-suspend/71715/2
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    }

    ../../peripherals/fingerprint-scanner.nix
  ];
}
