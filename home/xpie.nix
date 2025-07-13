{ config, pkgs, ... }:

{
  home.username = "xpie";
  home.homeDirectory = "/home/xpie";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.zsh.enable = true;

  home.packages = with pkgs; [
    firefox
    neovim
  ];
}
