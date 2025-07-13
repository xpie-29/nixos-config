{
  description = "NixOS with flakes and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      overlays = [
        (import ./overlays/openrazer-updated.nix)
      ];
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixblade = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/nixblade.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.xpie = import ./home/xpie.nix;
          }
        ];

        # ❌ No `overlays` or `pkgs` here
      };
    };
}
