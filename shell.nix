{ pkgs ? import <nixpkgs> {} }:

let
  easyPS = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "7f6207b9e9b021e30d6c82f49ba20f0d5db01d1f";
    sha256 = "1j02jcs88fyc0diyyym1y3yhrhpjj7jcdj9aw8sfcd20yrpd4pbr";
  }) {
    inherit pkgs;
  };
in
  pkgs.mkShell {
    buildInputs = [
      easyPS.purs-0_14_7
      easyPS.spago
      easyPS.pulp
      easyPS.psc-package
      pkgs.nodejs-14_x
      pkgs.nodePackages.bower
    ];

    shellHook = ''
      export PATH=$PWD/node_modules/.bin:$PATH
    '';
  }
