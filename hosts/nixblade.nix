{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      ./hardware-configuration.nix
    ];

  # BOOTLOADER
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev"; # Required for EFI system
  boot.loader.grub.useOSProber = false; # Set true if dual-booting
  boot.loader.efi.canTouchEfiVariables = true;

  # LINUX KERNEL
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # HOSTNAME
  networking.hostName = "nixblade";

  # NETWORK MANAGER
  networking.networkmanager.enable = true;

  # TIME ZONE
  time.timeZone = "America/New_York";

  # LOCALISATION
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # NVIDIA DRIVERS
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # GRAPHICAL ENVIRONMENT
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1"; # for Hyprland workaround
    GBM_BACKEND = "nvidia-drm";
    __GL_GSYNC_ALLOWED = "1";
  };

  # FIRMWARE
  hardware.firmware = with pkgs; [
    linux-firmware  # Intel Wi-Fi + Bluetooth + generic blobs
    sof-firmware    # Intel Raptor Lake + SOF audio support
  ];

  # PRINTING
  services.printing.enable = true;

  # AUDIO
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  # USER ACCOUNT
  users.users.xpie = {
    isNormalUser = true;
    group = "xpie";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };
  users.groups.xpie = {};

  security.sudo.wheelNeedsPassword = false; # Change to true after initial installation.

  # SYSTEM PACKAGES
  environment.systemPackages = with pkgs; [
    # Editors
    vim
    nano

    # Utilities
    git
    wget
    curl
    htop
    glxinfo
    openrazer-daemon
    polychromatic # Razer laptop/peripherals lighting control
  ];

  # PROGRAMS
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # SOFTWARE REQUIRING WRAPPERS

  # FONTS
  fonts.packages = with pkgs; [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # SERVICES
  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # DO NOT CHANGE THE SYSTEM.STATEVERSION
  system.stateVersion = "25.05";
}
