{ config, pkgs, lib, inputs, ... }:
let
  # Firefox Profile Setting States
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
  home.username = "kb";
  home.homeDirectory = "/home/kb";
  home.packages = with pkgs; [
    # System
    kdePackages.kate
    kdePackages.kcalc
    fastfetch
    btop
    filelight
    # Office
    thunderbird
    libreoffice-qt
    logseq
    xournalpp
    xournal
    rnote
    # Security
    gnupg
    keepassxc
    pass-wayland
    veracrypt
    protonvpn-gui
    mosh # Mobile Shell
    # Media
    freetube
    inkscape
    blender
    cheese
    gimp
    vlc
    kid3
    tidal-hifi
    bookworm
    foliate
    # Tools
    transmission_4-qt
    prusa-slicer
    xorg.xkbcomp
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    #kicad
    dig
    # Messengers
    element-desktop # Matrix Client
    telegram-desktop
    signal-desktop
    webcord
    # Customization
    firefoxpwa
    # Development
    vscodium
    scrcpy
    # Experiments
    # Gaming
    prismlauncher
  ];

  services.syncthing.enable = true;
  services.syncthing.extraOptions = [
    "--config=/home/kb/.config/syncthing"
    "--data=/home/kb/sync"
  ];

  services.gpg-agent.enable = true;

  services.ssh-agent.enable = true;

  services.kdeconnect.enable = true;

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
    policies = {
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
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4362793/consent_o_matic-1.1.3.xpi";
          installation_mode = "normal_installed";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4382536/ublock_origin-1.61.0.xpi";
          installation_mode = "normal_installed";
        };
        "keepassxc-browser@keepassxc.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4376326/keepassxc_browser-1.9.4.xpi";
          installation_mode = "normal_installed";
        };
        "offline-qr-code@rugk.github.io" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4349427/offline_qr_code_generator-1.9.xpi";
          installation_mode = "normal_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4378073/darkreader-4.9.96.xpi";
          installation_mode = "normal_installed";
        };
        "firefoxpwa@filips.si" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4383345/pwas_for_firefox-2.13.1.xpi";
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
  };

  home.stateVersion = "24.05";
}
