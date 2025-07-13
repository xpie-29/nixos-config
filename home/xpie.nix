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

    # Enable autosuggestions
    autosuggestion.enable = true;

    # Enable syntax highlighting
    syntaxHighlighting.enable = true;

    # Extra Zsh config snippets
    initContent = ''
      # Optional: adjust colors for autosuggestions
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
    '';
  };

  # PACKAGES
  home.packages = with pkgs; [

    # Internet
    vivaldi
    vivaldi-ffmpeg-codecs
    firefox

    # Editors
    neovim
    kitty
    kitty-themes
  # starship
  ];
}
