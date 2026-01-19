{ pkgs, util, ... }:

let
  pythonBinaries =
    util.allBinariesMatchingIn "${pkgs.python3}/bin" "^(python[[:digit:].]*)$";
  injectNixLd = binary:
    (pkgs.writeShellScriptBin binary ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      exec ${pkgs.python3}/bin/${binary} "$@"
    '');
  pythonWrappers = map injectNixLd pythonBinaries;
in { environment.systemPackages = pythonWrappers; }
