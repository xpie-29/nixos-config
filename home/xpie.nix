{ config, pkgs, lib, ... }:

{
  home.username = "xpie";
  home.homeDirectory = lib.mkForce "/home/xpie";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.zsh.enable = true;

  home.packages = with pkgs; [
    firefox
    neovim
  ];
}
