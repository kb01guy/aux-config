# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.permittedInsecurePackages = [
                "electron-27.3.11"
              ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg)
  [
    "veracrypt"
    "steam"
    "steam-original"
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
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kb = {
    isNormalUser = true;
    description = "kb";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      fastfetch
      btop
      testdisk
      neofetch
      xournalpp
      xournal
      rnote
      mypaint
      firefox
      vim
      filelight
      taxi
      transmission_3
      transmission-remote-gtk
      bookworm
      foliate
      filelight
      micropython
      mpy-utils
      logseq
      keepassxc
      terminator
      thunderbird
      blender
      prismlauncher
      prusa-slicer
      xorg.xkbcomp
      krita
      veracrypt
      libreoffice-qt
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US
      languagetool
      freetube
      signal-desktop
      kicad
      protonvpn-gui
      kotatogram-desktop
      vlc
      filezilla
      inkscape
      obs-studio
      steam
      iamb # Matrix CLI
      element-desktop # Matrix GUI
      dig
      alacritty # Terminal
      zed-editor # Editor
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.kdeconnect.enable = true;

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.firefox.nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  programs.ssh.startAgent = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.syncthing = {
    enable = true;
    user = "kb";
    dataDir = "/home/kb";
    configDir = "/home/kb/.config/syncthing";
  };
  services.transmission.settings = {
    download-dir = "${config.services.transmission.home}/Torrents";
  };
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
