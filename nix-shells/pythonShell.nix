{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages; [
        python311
        python311Packages.numpy
        python311Packages.pandas
        python311Packages.matplotlib
        python311Packages.pyrtlsdr
    ];
}
