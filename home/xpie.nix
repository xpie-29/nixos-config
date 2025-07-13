{ config, pkgs, lib, ... }:

{
  home.username = "xpie";
  home.homeDirectory = lib.mkForce "/home/xpie";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

# ZSHELL
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "jonathan";
      plugins = [ "git" "z" "extract" ];
    };
  };

  # STARSHIP

  # KITTY
  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font Mono";
    font.size = 12;
    theme = "Nordfox";
    settings = {
      scrollback_lines = 10000;
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      window_padding_width = 6;
      background_opacity = "0.9";
      background_blur = 3;
    };
  };

  home.packages = with pkgs; [

    # Internet
    vivaldi
    vivaldi-ffmpeg-codecs
    firefox

    # Editors
    neovim
  ];
}
