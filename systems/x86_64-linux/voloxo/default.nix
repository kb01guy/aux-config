{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];

  # Configure Nix
  nix.package = pkgs.lix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
    "olm-3.2.16"
  ];
  nix.settings.trusted-users = [ "remotebuild" ]; # UNSAVE, Remove ASAP
  nix.settings.trusted-public-keys = [
    "cache.HyperC:90YNJ0eWsuBGVVP989lJh1rL8C0KM6IKbAtEUiu+FCU="
  ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Crosscompiling
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "voloxo"; # Define your hostname.
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



  # Nvidia Configuration
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,dv2,de";
    variant = "esc:swapcaps";
    extraLayouts.dv2 = {
      description = "German Dvorak Type 2";
      languages = [ "de" ];
      symbolsFile = ./symbols/dv2;
    };
  };

  # Configure console keymap
  console.keyMap = "de";

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
      firefox
      kate
      thunderbird
      cheese
      obs-studio
      # blender
      syncthing
      keepassxc
      freetube
      libreoffice
      adafruit-nrfutil
      prismlauncher
      gimp
      inkscape
      veracrypt
      matrix-commander
      vlc
      protonvpn-gui
      telegram-desktop
      logseq
      signal-desktop
      kid3
      #calibre
      spotify-player
      tidal-hifi
      iamb # Matrix with Vim-Binds
      yazi
      nerdfonts
      scrcpy
      ryujinx
      razergenie
      webcord
      mangohud
      vscodium
      pass-wayland
      gnupg
      kdePackages.kcalc
      
    ];
  };

  users.users.remotebuild = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID8CBRiViR+JVFHEeeUbeHLY4gCvZ1TTlt63HlBD8xls Remotebuilds from HyperC"
    ];
  };
  
  # Define Service Users
  users.groups.languagetool = {};
  users.users.languagetool = {
    isSystemUser = true;
    group = "languagetool";
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kb";


  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
  programs.ssh.startAgent = true;
  programs.kdeconnect.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  
  programs.firefox.enable = true;
  programs.firefox.nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    fastfetch
    usbutils
    fprintd
    nss
    mesa
    python3
    zulu
    zulu8
    languagetool
    btop
    firefoxpwa
    bookworm
    foliate
    gparted
    git 
    ntfs3g
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  systemd.services.languagetool = {
    description = "LanguageTool HTTP Server for local Spellchecking";
    wants = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/languagetool-http-server --port 8081 --allow-origin '*'";
      WorkingDirectory = "~"; # Defaults to "/" If the user has no home
      User = "languagetool";
      Restart = "always";
      RestartSec = 30;
    };
  };

#  services.udev.extraRules = ''
#ENV{ID_VENDOR_ID}=="EloTouchSystems_Inc",ENV{ID_MODEL_ID}=="Elo_TouchSystems_2216_AccuTouch®_USB_Touchmonitor_Interface",ENV{WL_OUTPUT}="DP-0",ENV{LIBINPUT_CALIBRATION_MATRIX}="0.4 0 0  0 -0.347826087 0.652173913"
#'';

#  services.xserver.inputClassSections = [
#    ''
#        Identifier      "calibration"
#        MatchProduct    "EloTouchSystems,Inc Elo TouchSystems 2216 AccuTouch® USB Touchmonitor Interface"
#        Option  "MinX"  "6225"
#        Option  "MaxX"  "59846"
#        Option  "MinY"  "57849"
#        Option  "MaxY"  "5925"
#        Option  "InvertY" "1"
#    ''
#  ];

  # Virtualisation
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  services.syncthing = {
	    enable = true;
	    user = "kb";
	    dataDir = "/home/kb/sync";
	    configDir = "/home/kb/.config/syncthing";
	  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-voloxo-priv-key.pem";
  };

  # Do NOT change this value
  system.stateVersion = "23.05"; # Did you read the comment?

}
