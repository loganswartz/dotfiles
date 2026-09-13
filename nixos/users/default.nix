{ config, lib, util, ... }:

let
  # every subdirectory of ./users is a user; each must hold a `default.nix`
  # (NixOS config) and a `home.nix` (home-manager config)
  available = util.subdirectoriesOf ./.;
in
{
  # `imports` may never depend on `config`, so every user's system module is
  # imported on every host and each one gates its own config on `host.users` --
  # the same shape as any upstream NixOS service module.
  #
  # `importApply` hands the module the directory name as `username` while letting
  # the module system apply the real argument set (pkgs, config, the flake inputs
  # from specialArgs) underneath, and keeps the file path for error messages.
  # Note it isn't re-exported as `lib.importApply`.
  imports = map (
    username: lib.modules.importApply ./${username} { inherit username; }
  ) available;

  options.host.users = lib.mkOption {
    type = lib.types.listOf (lib.types.enum available);
    default = [ "logans" ];
    example = [
      "logans"
      "guest"
    ];
    description = ''
      Users from `./users` to configure on this host. Each name gets its system
      config from `users/<name>/default.nix` and its home-manager config from
      `users/<name>/home.nix`.

      Being a list, definitions concatenate rather than override, but the default
      only applies when no module defines the option at all, so a host setting
      this replaces the default cleanly.
    '';
  };

  config.home-manager.users =
    lib.genAttrs config.host.users (username: import ./${username}/home.nix);
}
