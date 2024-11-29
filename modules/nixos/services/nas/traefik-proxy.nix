{
  inputs,
  config,
  lib,
  pkgs,
  system,
  ...
}:
let
  cfg = config.services.nas;
in
{
  config = lib.mkIf (cfg.enable && cfg.useTraefik.enable) {

    services.traefik = {
      enable = true;
      staticConfigOptions = {
        entryPoints.web.address = ":80";
        entryPoints.websecure.address = ":443";
      };
    };
  };
}

