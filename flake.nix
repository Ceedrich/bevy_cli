{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [(import rust-overlay)];
    };
  in {
    packages.${system} = rec {
      bevy_cli-unwrapped = pkgs.callPackage ./bevy_cli-unwrapped.nix {};
      bevy_cli = pkgs.callPackage ./bevy_cli.nix {inherit bevy_cli-unwrapped;};
      default = self.packages.${system}.bevy_cli;
    };
  };
}
