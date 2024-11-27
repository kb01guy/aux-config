{ config, lib, pkgs, modulesPath, ... }:
{
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 4*1024;
      cores = 3;         
    };
  };
}
