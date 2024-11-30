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
    # Default Config
    services.traefik = {
      enable = true;
      staticConfigOptions = {
        entryPoints.web.address = ":80";
        entryPoints.websecure.address = ":443";
      };
    };
    networking.firewall.interfaces.eth0.allowedTCPPorts = [ 80 443 ];

    # Enable Secure Dashboard
    services.traefik.staticConfigOptions.api = {};
    services.traefik.dynamicConfigOptions = {
      http.routers.dashboard.entrypoints = "websecure";
      http.routers.dashboard.tls = true;
      http.routers.dashboard.rule = "Host(`traefik.localhost`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
      http.routers.dashboard.service = "api@internal";
      http.routers.dashboard.middlewares = "auth";
      http.middlewares.auth.basicauth.users = "master:\$\$2y\$\$05\$\$JwzsNHz7CMJh0RU1eMe3AOfY5H30Qr1Q/glS1r/qEHCNpo5LvWnRW";
    };

  };
}

