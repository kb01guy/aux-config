{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-data = {
      url = "github:snowflakelinux/nix-data";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowflakeos-modules.url = "github:snowflakelinux/snowflakeos-modules";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config.allowUnfree = false;
      systems.modules.nixos = with inputs; [
        nix-data.nixosModules.nix-data
#        snowflakeos-modules.nixosModules.efiboot
#        snowflakeos-modules.nixosModules.gnome
#        snowflakeos-modules.nixosModules.kernel
#        snowflakeos-modules.nixosModules.networking
#        snowflakeos-modules.nixosModules.packagemanagers
#        snowflakeos-modules.nixosModules.pipewire
#        snowflakeos-modules.nixosModules.printing
#        snowflakeos-modules.nixosModules.snowflakeos
#        snowflakeos-modules.nixosModules.metadata
      ];
#      nixosConfigurations.HyperC = nixpkgs.lib.nixosSystem {
#        modules = [
          # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
#          nixos-hardware.nixosModules.microsoft-surface-pro-intel
#        ];
#      };
    };
}

