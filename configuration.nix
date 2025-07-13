{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
#  boot.loader.systemd-boot.enable = true;
#  boot.loader.efi.canTouchEfiVariables = true;

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

  hardware.opengl.enable = true;

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

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # USER ACCOUNT
  users.users.xpie = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "Fantasy7!.";
    packages = with pkgs; [
    
    ];
  };

  security.sudo.wheelNeedsPassword = false; # Change to true after initial installation.

  programs.firefox.enable = true; # Remove after Vivaldi is setup

  # SYSTEM PACKAGES
  environment.systemPackages = with pkgs; [
    vim nano git wget curl htop glxinfo
  ];

  # SOFTWARE REQUIRING WRAPPERS

  # SERVICES
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

