# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];

  # Configure Nix
  nix.package = pkgs.lix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg)
  [
    "veracrypt"
    "steam"
    "steam-original"
    "steam-unwrapped"
  ];

  # Configure Remote Builds
  nix.settings.trusted-public-keys = [
    "cache.kb-games-01:Y9lGS9lw+grILNY+Mmw498mMoBQcYE+OqTpOHBAOajw="
  ];
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "kb-games-01-remotebuild";
      system = "x86_64-linux";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ "big-parallel" ];
    }
    # {
    #   hostName = "voloxo-remotebuild";
    #   system = "x86_64-linux";
    #   maxJobs = 6;
    #   speedFactor = 6;
    #   supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    #   mandatoryFeatures = [ "big-parallel" ];
    # }
  ];

#  services.tlp.enable = true;
  powerManagement.cpufreq.max = 3500000;
#  powerManagement.cpufreq.min =  400000;

  hardware.bluetooth.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
#  boot.plymouth.enable = false;

  networking.hostName = "HyperC"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.libinput.touchpad.naturalScrolling = true;
  services.xserver = {
    wacom.enable = true;

    xkb = {
      layout = "us,dv2,de";
      variant = "caps:swapescape";
      extraLayouts.dv2 = {
        description = "German Dvorak Type 2";
        languages = [ "de" ];
        symbolsFile = ./symbols/dv2;
      };
    };
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.kb = { # Managed via Home-Manager
    isNormalUser = true;
    description = "kb";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git # Add first because Flakes use git
    vim
    onboard
    libcamera
    wget
    file
    zulu
    squeekboard
    maliit-keyboard
    gparted
  ];

  # Set default Editor
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  programs.ssh.startAgent = true;

  # List services that you want to enable:
  services.transmission.settings = {
    download-dir = "${config.services.transmission.home}/Torrents";
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-HyperC-priv-key.pem";
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}
