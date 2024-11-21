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
  config = lib.mkIf (cfg.enable && cfg.servers.survival.enable) {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "minecraft-server"
    ];

    services.minecraft-servers.servers."survival" = {
      enable = true;
      autoStart = true;
      enableReload = true;
      package = pkgs.paperServers.paper-1_21_3-build_25;
      whitelist = {
        kB01guy = "1ff88b66-beda-4386-85b9-a00a5c27437a";
      };
      openFirewall = true;
      symlinks = {
        "plugins/LuckPerms.jar" = pkgs.fetchurl { url = "https://download.luckperms.net/1561/bukkit/loader/LuckPerms-Bukkit-5.4.146.jar"; sha512 = "3yx163xas6g30crj41ad8j9gh55ygfh7vbaq12hlm4rxf1npnxh95rhn2nx0qcjd4nl1rz8f8pbvmlh6ka32ahvn6x9rxsc8g6v24jz"; };
      };
    };
  };
}

