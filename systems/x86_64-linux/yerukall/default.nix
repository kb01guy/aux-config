# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, inputs,... }:
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  lock-empty-string = {
    Value = "";
    Status = "locked";
  };
in {
  imports =
  [
    ./hardware.nix
    inputs.sops-nix.nixosModules.sops
#    inputs.home-manager.nixosModules.home-manager
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure Secret Management
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.secrets.example-key = {};
  sops.secrets."myservice/my_subdir/my_secret" = {};

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "yerukall"; # Define your hostname.
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
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap
  services.xserver.xkb = {
    variant = "caps:swapescape";
    layout = "de,us,dv2";
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

  # Enable Bluetooth Support
  hardware.bluetooth.enable = true;
#  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kb-work = {
    isNormalUser = true;
    description = "kb-work";
    extraGroups = [ "vboxusers" "networkmanager" "wheel" ];
    packages = with pkgs; [
      kate
      thunderbird
      keepassxc
      globalprotect-openconnect
      vscodium
      logseq
      ungoogled-chromium
      zed-editor # Editor
      languagetool
      syncthing
      pysolfc
      blender
      prusa-slicer
      kcalc
      veracrypt
      zoom-us
      virtualbox
      protonvpn-gui
      tidal-hifi
      gimp
      libreoffice
      sops # Secret Management
    ];

  };

  services.syncthing = {
    enable = true;
    user = "kb-work";
    dataDir = "/home/kb-work";
    configDir = "/home/kb-work/.config/syncthing";
  };

  services.languagetool = {
    enable = true;
    allowOrigin = "*";
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
#    enable = true;
    pinentryPackage = pkgs.lib.mkForce pkgs.pinentry-qt;
  };

  programs.virt-manager.enable = true;

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
    policies = {
      # --------- Privacy ---------
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      OfferToSaveLogins = false;
      FirefoxHome.TopSites = false;
      FirefoxHome.SponsoredTopSites = false;
      Preferences = {
        "browser.newtabpage.pinned" = lock-empty-string;
        "browser.topsites.contile.enabled" = lock-false;
      };
      # -------- Opiniated --------
      DontCheckDefaultBrowser = true;
      DisableProfileImport = true;
      SearchBar = "unified";
      SearchEngines.Add = [ # Only Available in ESR Releases https://mozilla.github.io/policy-templates/#searchengines--add
        {
          Name = "Brave";
          URLTemplate = "https://search.brave.com/search?q={SearchTerms}";
          Alias = "br";
        }
      ];
      ExtensionSettings = { # See https://mozilla.github.io/policy-templates/#extensionsettings
        "extension@tabliss.io" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/3940751/tabliss-2.6.0.xpi";
          installation_mode = "normal_installed";
        };
        "gdpr@cavi.au.dk" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4246350/consent_o_matic-1.0.13.xpi";
          installation_mode = "normal_installed";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4261710/ublock_origin-1.57.2.xpi";
          installation_mode = "normal_installed";
        };
        "keepassxc-browser@keepassxc.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4257616/keepassxc_browser-1.9.0.3.xpi";
          installation_mode = "normal_installed";
        };
        "offline-qr-code@rugk.github.io" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/3870992/offline_qr_code_generator-1.8.xpi";
          installation_mode = "normal_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4262984/darkreader-4.9.83.xpi";
          installation_mode = "normal_installed";
        };
        "firefoxpwa@filips.si" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4252822/pwas_for_firefox-2.11.1.xpi";
          installation_mode = "normal_installed";
        };
      };
      Bookmarks = [
        {
          Title = "Syncthing";
          URL = "localhost:8384";
          Placement = "toolbar";
        }
      ];
    };

#    profiles.default = {
#      id = 0;
#      name = "default";
#      isDefault = true;
#      path = "/home/spiegelma/.mozilla/firefox/m9zcjjpu.default";
#    };

#    profiles.work = {
#      id = 1;
#      name = "work";
#      isDefault = false;
#      search = {
#        force = true;
#        default = "Brave";
#        order = [ "Brave" "StartPage" "DuchDuckGo" "Google" "Bing"];
#        engines = {
#          "Brave" = {
#            urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
#            iconUpdateURL = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-search-icon.CsIFM2aN.svg";
#            updateInterval = 24 * 60 * 60 * 1000; # every day
#          };
#          "StartPage" = {
#            urls = [{ template = "https://www.startpage.com/sp/search?query={searchTerms}"; }];
#            iconUpdateURL = "https://www.startpage.com/sp/cdn/favicons/favicon-16x16-gradient.png";
#            updateInterval = 24 * 60 * 60 * 1000; # every day
#          };
#        };
#      };
#      bookmarks = [
#        {
#          name = "work";
#          toolbar = true;
#          bookmarks = [
#            {
#              name = "ohmportal";
#              url = "https://my.ohmportal.de/";
#            }
#          ];
#        }
#        {
#          name = "nixos";
#          toolbar = true;
#          bookmarks = [
#            {
#              name = "nix Packages";
#              url = "https://search.nixos.org/packages?channel=unstable";
#            }
#            {
#              name = "nix Options";
#              url = "https://search.nixos.org/options?channel=unstable";
#            }
#            {
#              name = "home Options";
#              url = "https://nix-community.github.io/home-manager/options.xhtml";
#            }
#          ];
#        }
#      ];
#    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    ];
    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
  };

  # Configure Nix
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-28.3.3"
    "electron-27.3.11"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    btop
    starship
    openconnect
    firefoxpwa
    gnupg
    pinentry-qt
    cifs-utils # Needed to access SMB Shares
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  
  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # start SSH Agent
  programs.ssh.startAgent = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.globalprotect = {
    enable = true;
    settings = {
      "vpn.ohmportal.de" = {
        openconnect-args = "--protocol gp --disable-ipv6 --mtu=1284 --force-dpd=30 ";
      };
    };
    csdWrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
  };

#  virtualisation.virtualbox.host = {
#    enable = true;
#    enableKvm = true;
#    enableHardening = false; # Incompatible with KVM
#    addNetworkInterface = false; # Incompatible with KVM
#  };
  virtualisation.libvirtd.enable = true;

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
  system.stateVersion = "23.11"; # Did you read the comment?
}
