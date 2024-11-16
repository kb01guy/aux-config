{ config, lib, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware.nix
  ];

  # Configure Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-public-keys = [
    "cache.HyperC:90YNJ0eWsuBGVVP989lJh1rL8C0KM6IKbAtEUiu+FCU="
  ];
  nix.package = pkgs.lix;
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "kb-games-01";

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.master = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKLbU0GpeqkYOsccsddQgZAppd5SFiokGAfjKr+dEEjY kb HyperC"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHS3DoQe/4TtdTLD/Fl41rTjE0n5MyFMl59VGVejcskO kb voloxo"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPpN/3esM0SFLJ2guCBOYX8IdBC+jUiMF+xPYkTEuzbe kb-work yerukall"
    ];
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      vim
    ];
  };

  users.users.remotebuild = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHdxVb42GEb/rwrsQx/Wc2v2P+WIq8/WNlF+l31Rl/a Remotebuilds from HyperC"
    ];
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # SSH and Mosh
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    ports = [ 3422 ];
    openFirewall = true;
  };
  programs.mosh.enable = true;

  # Minecraft Servers
  services.minecraft = {
    enable = true;
    servers.vanilla.enable = false;
    servers.survival.enable = true;
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-kb-games-01-priv-key.pem";
  };

  # Do NOT change this value 
  system.stateVersion = "24.05"; # Did you read the comment?
}

