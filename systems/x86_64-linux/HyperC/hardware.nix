# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, inputs, ... }: let
  inherit (inputs) nixos-hardware;
in {
  imports =
    [ 
      (modulesPath + "/installer/scan/not-detected.nix")
      nixos-hardware.nixosModules.microsoft-surface-pro-intel
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
#  boot.initrd.systemd.enable = true;
#  boot.initrd.unl0kr.enable = true;

  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/93d26de6-3831-4c1f-95ea-b7b158730749";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-cae8c5d5-29a6-4e1e-a64d-294042c93d6e".device = "/dev/disk/by-uuid/cae8c5d5-29a6-4e1e-a64d-294042c93d6e";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7047-5531";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ { device = "/swapfile"; size = 8 * 1024; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
