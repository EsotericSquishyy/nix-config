{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages; [
        (python3.withPackages (ps: with ps; with python3Packages; [
            jupyter
            ipython
            pandas
            scipy
            numpy
            matplotlib
        ]))
    ];

    shellHook = "jupyter-notebook";
}
