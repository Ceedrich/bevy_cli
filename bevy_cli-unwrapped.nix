{
  lib,
  rust-bin,
  makeRustPlatform,
  pkg-config,
  openssl,
  installShellFiles,
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
      installShellFiles
    ];

    buildInputs = [
      openssl
    ];

    doCheck = false;

    postInstall = ''
      installShellCompletion --cmd bevy \
        --bash <($out/bin/bevy completions bash) \
        --fish <($out/bin/bevy completions fish) \
        --zsh  <($out/bin/bevy completions zsh)
    '';

    meta = {
      description = "Bevy Cli";
      homepage = "https://github.com/TheBevyFlock/bevy_cli";
      license = lib.licenses.mit;
      maintainers = [];

      mainProgram = "bevy";
    };
  }
