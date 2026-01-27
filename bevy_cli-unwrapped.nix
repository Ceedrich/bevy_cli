{
  rust-bin,
  makeRustPlatform,
  pkg-config,
  openssl,
}: let
  rustToolchain = rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
  rustPlatform = makeRustPlatform {
    cargo = rustToolchain;
    rustc = rustToolchain;
  };
in
  rustPlatform.buildRustPackage {
    name = "bevy_cli";
    src = ./.;
    cargoLock.lockFile = ./Cargo.lock;

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      openssl
    ];

    doCheck = false;
  }
