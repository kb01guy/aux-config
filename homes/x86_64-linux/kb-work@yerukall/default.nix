{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.internal;{
  snowfallorg.user.enable = true;
  snowfallorg.user.name = "kb-work";
#  home.stateVersion = "24.05";


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
