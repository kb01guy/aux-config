{
  inputs,
  config,
  lib,
  pkgs,
  system,
  ...
}:
let
  cfg = config.services.minecraft;
in
{
  config = lib.mkIf (cfg.enable && cfg.servers.vanilla.enable) {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "minecraft-server"
    ];

    services.minecraft-servers.servers."vanilla-test" = {
      enable = true;
      autoStart = true;
      enableReload = true;
      package = pkgs.vanillaServers.vanilla;
      whitelist = {
        kB01guy = "1ff88b66-beda-4386-85b9-a00a5c27437a";
      };
      openFirewall = true;
    };
  };
}

