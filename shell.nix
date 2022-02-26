{ pkgs ? import <nixpkgs> {} }:

let
  easyPS = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "3630943b74f681289ed87a0ed6c3e502556ddebb";
    sha256 = "1i7zqda52npklj3d7pq80zw5rfjjzdqpl5bdrsp6vchg5frgj6ky";
  }) {
    inherit pkgs;
  };
in
  pkgs.mkShell {
    buildInputs = [
      easyPS.purs-0_14_5
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
