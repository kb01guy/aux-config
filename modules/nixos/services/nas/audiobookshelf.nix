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
  config = lib.mkIf (cfg.enable && cfg.servers.audiobookshelf.enable) {

    services.audiobookshelf = {
      enable = true;
      port = 63001;
    };

    services.traefik.dynamicConfigOptions = {
      http.routers.audiobookshelf.entrypoints = "websecure";
      http.routers.audiobookshelf.tls = true;
      http.routers.audiobookshelf.rule = "Host(`audiobookshelf.localhost`)";
      http.routers.audiobookshelf.service = "audiobookshelf";
      services.audiobookshelf.loadBalancer.servers = [ { url = "http://localhost:63001/"; } ];
    };
  };
}

