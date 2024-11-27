{ config, lib, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./vm.nix
  ];

  # Configure Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.package = pkgs.lix;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "U3ncSovm";

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.master = {
    initialPassword = "test";
    openssh.authorizedKeys.keys = [
    ];
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      vim
      fastfetch
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
    ports = [ 5530 ];
    openFirewall = true;
  };
  programs.mosh.enable = true;

  # Do NOT change this value 
  system.stateVersion = "24.05"; # Did you read the comment?
}

