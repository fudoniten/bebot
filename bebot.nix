{ lib, stdenv, clojure, fetchgit, fetchMavenArtifact, gitignoreSource
, callPackage, writeText, writeShellScript, ... }:

let
  base-name = "bebot";
  version = "0.1";
  full-name = "${base-name}-${version}";

  cljdeps = callPackage ./deps.nix { inherit fetchgit fetchMavenArtifact lib; };
  classpath = cljdeps.makeClasspaths { };

  pthru = o: builtins.trace o o;

in stdenv.mkDerivation {
  name = "${full-name}.jar";
  src = gitignoreSource ./.;
  buildInputs = [ clojure ] ++ map (d: d.paths) cljdeps.packages;
  buildPhase = pthru ''
    HOME=./home
    mkdir -p $HOME
    clojure -Scp ./src:${classpath} -X:build build/uberjar :project org.fudo/bebot :version 0.1
  '';
  installPhase = ''
    cp ./target/bebot-${version}-standalone.jar $out
  '';
}
