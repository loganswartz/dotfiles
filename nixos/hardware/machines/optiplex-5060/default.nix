{ nixos-hardware, pkgs, ... }:

{
  imports = [
    # closest comparable nixos-hardware preset
    nixos-hardware.nixosModules.dell-optiplex-3050
  ];
}
