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
        api = {
          insecure = true;
        };
      };
      dynamicConfigOptions = {
        # http.routers.dashboard.entrypoints = "websecure";
        # http.routers.dashboard.tls = true;
        # http.routers.dashboard.rule = "Host(`traefik.localhost`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
        # http.routers.dashboard.service = "api@internal";
        # http.routers.dashboard.middlewares = "auth";
        # http.middlewares.auth.basicauth.users = "master:\$\$2y\$\$05\$\$YWM0ZknINeHpJsNqqsd91eF/yl.S8t12TPQsDmf92glrjGW9Y1RvO";
      };
    };
  };
}

