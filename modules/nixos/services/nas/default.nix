{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.services.nas;
in
{
  imports = [
    ./traefik-proxy.nix
    ./audiobookshelf.nix
  ];

  options.services.nas = {
    enable = lib.mkOption {
      type = with lib.types; uniq bool;
      default = false;
      description = "Enable NAS Server Configuration";
    };
    useTraefik.enable = lib.mkOption {
      type = with lib.types; uniq bool;
      default = true;
      description = "Enables Traefik Reverese Proxy";
    };
    servers.audiobookshelf.enable = lib.mkOption {
      type = with lib.types; uniq bool;
      default = false;
      description = "Audiobookshelf Server";
    };
  };
}

