{ pkgs, util, ... }:

let
  luaBinaries = util.allBinariesMatchingIn "${pkgs.lua51Packages.luarocks}/bin" "^(luarocks.*)$";
  injectNixLd =
    binary:
    (pkgs.writeShellScriptBin binary ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      exec ${pkgs.lua51Packages.luarocks}/bin/${binary} "$@" RT_DIR=${pkgs.glibc}
    '');
  luaWrappers = map injectNixLd luaBinaries;
in
{
  environment.systemPackages = luaWrappers;
}
