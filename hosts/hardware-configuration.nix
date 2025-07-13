{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];


  boot.initrd.luks.devices = {
    crypt0 = {
      device = "/dev/disk/by-partlabel/luks4tb";
      preLVM = true;
    };
    crypt1 = {
      device = "/dev/disk/by-partlabel/luks2tb";
      preLVM = true;
    };
  };


  fileSystems."/" = {
     device = "/dev/nixvg0/root";
     fsType = "ext4";
  };

  fileSystems."/home" = {
     device = "/dev/nixvg0/home";
     fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "dev/disk/by-partlabel/ESP";
    fsType = "vfat";
    options = [ "noatime" "nodiratime" ];
  };

  swapDevices = [
    { device = "/dev/nixvg0/swap";}
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
