{ nixos-hardware, ... }:

{
  imports = [
    nixos-hardware.nixosModules.dell-xps-13-9360

    ../../peripherals/fingerprint-scanner.nix
  ];
}
