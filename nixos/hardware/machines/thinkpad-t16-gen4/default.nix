{ nixos-hardware, ... }:

{
  imports = [
    # closest comparable nixos-hardware preset
    nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen5

    ../../peripherals/fingerprint-scanner.nix
  ];
}
