{
  description = "NixOS Configuration";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, rust-overlay, nixos-hardware, ... }@inputs:
    let
      subdirectoriesOf = directory: builtins.attrNames (nixpkgs.lib.filterAttrs (k: v: v == "directory") (builtins.readDir directory));

      hosts = subdirectoriesOf ./hosts;
      users = subdirectoriesOf ./users;
    in {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts (hostname:
        nixpkgs.lib.nixosSystem {
          # pass all inputs to submodules
          specialArgs = inputs;
          modules = [
            { networking.hostName = hostname; }

            # Import the previous configuration.nix we used,
            # so the old configuration file still takes effect
            ./common
            ./hosts/${hostname}

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users = nixpkgs.lib.genAttrs users (username: import ./users/${username} );

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            }
            ({ pkgs, ... }: {
              nixpkgs.overlays = [ rust-overlay.overlays.default ];
              environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
            })
          ];
        }
      );
  };
}
