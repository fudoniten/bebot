{ lib, stdenv, clojure, fetchgit, fetchMavenArtifact, gitignoreSource
, callPackage, writeText, writeShellScript, ... }:

let
  base-name = "bebot";
  project = "org.fudo";
  version = "0.1";
  full-name = "${base-name}-${version}";

  cljdeps = callPackage ./deps.nix { inherit fetchgit fetchMavenArtifact lib; };
  classpath = cljdeps.makeClasspaths { };

  pthru = o: builtins.trace o o;

in stdenv.mkDerivation {
  name = "${full-name}.jar";
  src = ./.;
  buildInputs = [ clojure ] ++ (map (d: d.paths) cljdeps.packages);
  buildPhase = pthru ''
    HOME=./home
    mkdir -p $HOME
    clojure -Scp ${classpath}:./src -X:build build/uberjar :project ${project}/${base-name} :version ${version}
  '';
  installPhase = ''
    cp ./target/bebot-${version}-standalone.jar $out
  '';
}
