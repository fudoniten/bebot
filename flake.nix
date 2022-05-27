{
  description = "BeBot Mattermost chatbot Clojure library.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-21.05";
    utils.url = "github:numtide/flake-utils";
    clj2nix.url = "github:hlolli/clj2nix";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, clj2nix, gitignore, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        bebot-lib = pkgs.callPackage ./bebot.nix {
          inherit (gitignore.lib) gitignoreSource;
        };
      in {
        packages = utils.lib.flattenTree { inherit bebot-lib; };
        defaultPackage = self.packages."${system}".bebot-lib;
        overlay = final: prev: { inherit bebot-lib; };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            bash
            clojure
            jre

            clj2nix.packages."${system}".clj2nix
          ];
        };
      });
}
