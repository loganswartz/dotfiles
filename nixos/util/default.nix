{ nixpkgs, ... }:

{
  subdirectoriesOf = directory:
    builtins.attrNames (nixpkgs.lib.filterAttrs (k: v: v == "directory")
      (builtins.readDir directory));
  allBinariesMatchingIn = directory: pattern:
    builtins.attrNames (nixpkgs.lib.filterAttrs (k: v:
      let matches = builtins.match pattern k;
      in matches != null && builtins.length matches != 0)
      (builtins.readDir directory));
}
