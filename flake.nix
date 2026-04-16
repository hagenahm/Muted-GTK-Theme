{
  description = "Muted GTK theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f:
        lib.genAttrs systems (system:
          f (import nixpkgs { inherit system; }));
    in {
      packages = forAllSystems (pkgs: {
        default = pkgs.callPackage ./gtk-theme.nix { };
      });

      lib.mkTheme = { pkgs, color ? "-Light", subcolor ? "-Teal", colorTweak ? "" }:
        pkgs.callPackage ./gtk-theme.nix {
          inherit color subcolor colorTweak;
        };
    };
}
