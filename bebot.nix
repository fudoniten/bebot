{ lib, stdenv, bash, clojure, gitignoreSource, callPackage, ... }:

let
  base-name = "bebot";
  version = "0.1";
  full-name = "${base-name}-${version}";
  jar-name = "${base-name}.jar";

  cljdeps = callPackage ./deps.nix { };
  classpath = cljdeps.makeClasspaths { };

in stdenv.mkDerivation {
  name = full-name;
  src = gitignoreSource ./.;
  buildInputs = [ bash clojure ] ++ map (d: d.paths) cljdeps.packages;
  buildPhase = ''
    ./uberdeps/package.sh ./target/${jar-name}
  '';
  installPhase = ''
    cp ./target/${jar-name} $out
  '';
}
