{
  description = "NixOS with flakes and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  #  nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra/4.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixblade = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/nixblade.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.users.xpie = import ./home/xpie.nix;
          home-manager.backupFileExtension = "bak";
        }
      ];
    };
  };
}
