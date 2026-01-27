{
  installShellFiles,
  lib,
  makeBinaryWrapper,
  makeRustPlatform,
  openssl,
  pkg-config,
  rust-bin,
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
    cargoBuildFlags = ["--all"];

    nativeBuildInputs = [
      pkg-config
      installShellFiles
      makeBinaryWrapper
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

      for bin in $out/bin/bevy{,_lint}; do
        wrapProgram "$bin" \
          --set BEVY_LINT_SYSROOT ${rustToolchain}
      done
    '';

    meta = {
      description = "Bevy Cli";
      homepage = "https://github.com/TheBevyFlock/bevy_cli";
      license = lib.licenses.mit;
      maintainers = [];

      mainProgram = "bevy";
    };
  }
