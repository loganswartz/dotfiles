{ nixpkgs, ... }:

{
  subdirectoriesOf = directory: builtins.attrNames (nixpkgs.lib.filterAttrs (k: v: v == "directory") (builtins.readDir directory));
}
