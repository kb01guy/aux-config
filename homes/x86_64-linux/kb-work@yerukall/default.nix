{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.internal;{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];
  snowfallorg.user.enable = true;
  snowfallorg.user.name = "kb-work";
  home.stateVersion = "23.11";


  home.packages = with pkgs; [
    kate
    thunderbird
    keepassxc
    globalprotect-openconnect
    vscodium
    logseq
    ungoogled-chromium
    zed-editor # Editor
  ];
}
