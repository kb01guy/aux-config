{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: inputs.snowfall-lib.mkFlake {
    inherit inputs;
    src = ./.;

    channels-config.allowUnfree = false;

    nix.gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    nix.optimise.automatic = true;

    # Modules for Host voloxo
    systems.hosts.voloxo.modules = with inputs; [
    ];

    # Modules for Host kb-games-01
    systems.hosts.kb-games-01.modules = with inputs; [
    ];

    # Modules that get imported to every NixOS system
    systems.modules.nixos = with inputs; [
      lix-module.nixosModules.default
    ];

    outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };

  };
}

