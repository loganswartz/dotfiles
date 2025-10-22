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
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    nix-snapd = {
      url = "github:nix-community/nix-snapd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, flatpaks, nix-snapd, rust-overlay, ... }@inputs:
    let
      util = import ./util inputs;

      hosts = util.subdirectoriesOf ./hosts;
      users = util.subdirectoriesOf ./users;
    in {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts (hostname:
        nixpkgs.lib.nixosSystem {
          # pass all inputs to submodules
          specialArgs = inputs // { util = util; };
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
            flatpaks.nixosModules.default
            nix-snapd.nixosModules.default
            ({ pkgs, ... }: {
              nixpkgs.overlays = [ rust-overlay.overlays.default ];
              environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
            })
          ];
        }
      );
  };
}
