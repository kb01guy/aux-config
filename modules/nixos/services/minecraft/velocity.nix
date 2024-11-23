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
  config = lib.mkIf (cfg.enable && cfg.servers.velocity.enable) {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "minecraft-server"
    ];

    services.minecraft-servers.servers."velocity" = {
      enable = true;
      autoStart = true;
      enableReload = true;
      package = pkgs.velocityServers.velocity;
      openFirewall = true;
      symlinks = {
        "plugins/LuckPerms.jar" = pkgs.fetchurl { url = "https://download.luckperms.net/1561/velocity/LuckPerms-Velocity-5.4.146.jar"; sha512 = "1xk7fwb5z3bz0x3hpmnyg7cldzrf9anpp4aavq5s69lz2idzxvkjn9b5iv2yy22p17k26lqwfn8n9ivi59srz2hvgdb1jibqg5d5hj5"; };
      };
    };
  };
}

