{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.services.minecraft;
in
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./vanilla-test.nix
    ./survival.nix
    ./velocity.nix
  ];

  options.services.minecraft = {
    enable = lib.mkOption {
      type = with lib.types; uniq bool;
      default = false;
      description = "Enable minecraft server";
    };
    servers.vanilla.enable = lib.mkOption {
      type = with lib.types; uniq bool;
      default = false;
      description = "test server";
    };
    servers.survival.enable = lib.mkOption {
      type = with lib.types; uniq bool;
      default = false;
      description = "Survival Server";
    };
    servers.velocity.enable = lib.mkOption {
      type = with lib.types; uniq bool;
      default = false;
      description = "Velocity Proxy Server";
    };
  };

  config = lib.mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;
    };
  };
}

