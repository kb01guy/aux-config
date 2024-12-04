{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.services.forgejo-runner;
in
{
  options.services.forgejo-runner = {
    enable = lib.mkOption {
      type = with lib.types; uniq bool;
      default = false;
      description = "Enable Forgejo Runners";
    };
  };
  config = lib.mkIf (cfg.enable) {
    # services.gitea-actions-runner.package = pkgs.forgejo-runner;
    # services.gitea-actions-runner.instances."kb-one-runner@games-01" = {
    #   enable = true;
    #   name = "kb-one-runner@games-01";
    #   url = "https://git.kb-one.de/";
    #   tokenFile = "/opt/secrets/kb-one-runner@games-01_token";
    #   labels = [
    #     # provide a debian base with nodejs for actions
    #     "debian-latest:docker://node:18-bullseye"
    #     # fake the ubuntu name, because node provides no ubuntu builds
    #     "ubuntu-latest:docker://node:18-bullseye"
    #     # provide native execution on the host
    #     "native:host"
    #   ];
    #   hostPackages = with pkgs; [
    #     bash
    #     coreutils
    #     curl
    #     gawk
    #     gitMinimal
    #     gnused
    #     nodejs
    #     wget
    #     nix
    #   ];
    # };

    # systemd.services.forgejo-runner = {
    #   wantedBy = [ "multi-user.target" ];
    #   after = [ "docker.service" ];
    #   description = "";
    #   serviceConfig = {
    #     Type = "notify";
    #     User = "runner";
    #     WorkingDirectory = "/home/runner";
    #     ExecStart = ''${pkgs.forgejo-runner}/bin/forgejo-runner deamon''; 
    #     ExecStop = ''/bin/kill -s HUP $MAINPID'';
    #     Restart = "on-failure";
    #     TimeoutSec = 0;
    #     RestartSec = 10;
    #   };
    # };

    # users.users.runner = {
    #   isNormalUser = true;
    # };

    # environment.systemPackages = [ pkgs.forgejo-runner ];

    # virtualisation.podman.enable = true;
    # virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
    # virtualisation.podman.dockerCompat = true;

    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers."docker-in-docker" = {
      image = "docker:dind";
      hostname = "docker";
      extraOptions = [ "--privileged" "--network=kb-forgejo-runner" ];
      cmd = [ "dockerd" "-H" "tcp://docker:42349" "--tls=false" ];
    };
    virtualisation.oci-containers.containers."forgejo-runner" = {
      image = "code.forgejo.org/forgejo/runner:4.0.0";
      hostname = "forgejo-runner";
      extraOptions = [ "--network=kb-forgejo-runner" ];
      environment.DOCKER_HOST = "tcp://docker:42349";
      user = "1001:1001";
      volumes = [ "forgejo-runner-data:/data" ];
      cmd = [ "/bin/sh" "-c" "sleep 5; forgejo-runner daemon" ];
    };
  };
}

