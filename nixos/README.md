# NixOS config

Use with `sudo nixos-rebuild switch --flake .#<desired-host>`, where
`<desired-host>` is a subdirectory in `./hosts/`

## Users

Each subdirectory of `./users/` is a user, and holds both halves of their config:

- `default.nix` — NixOS config, applied only on hosts that enable the user
- `home.nix` — home-manager config

A host gets the users listed in `host.users`, which defaults to `[ "logans" ]`:

```nix
# hosts/<some-host>/default.nix
{
  host.users = [ "logans" "guest" ];
}
```
