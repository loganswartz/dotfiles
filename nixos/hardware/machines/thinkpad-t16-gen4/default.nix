{ nixos-hardware, ... }:

{
  imports = [
    # closest comparable nixos-hardware preset
    # (these are grouped together in fwupdmgr)
    nixos-hardware.nixosModules.lenovo-thinkpad-p16s-amd-gen4

    ../../peripherals/fingerprint-scanner.nix
  ];
}
