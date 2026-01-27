{
  lib,
  bevy_cli-unwrapped,
  runCommand,
  makeWrapper,
  cargo-generate,
}: let
  runtimePaths = [cargo-generate];
in
  runCommand bevy_cli-unwrapped.name {
    inherit (bevy_cli-unwrapped) name meta;
    nativeBuildInputs = [makeWrapper];
  } ''
    mkdir -p "$out/bin"
    makeWrapper ${lib.getExe' bevy_cli-unwrapped "bevy"} "$out/bin/bevy" \
      --prefix PATH : ${lib.makeBinPath runtimePaths} \
  ''
