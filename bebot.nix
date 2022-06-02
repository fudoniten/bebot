{ lib, stdenv, clojure, gitignoreSource, callPackage, writeText
, writeShellScript, ... }:

let
  base-name = "bebot";
  version = "0.1";
  full-name = "${base-name}-${version}";
  jar-name = "${base-name}.jar";

  cljdeps = callPackage ./deps.nix { };

  uberdeps-edn =
    writeText "deps.edn" ''{:deps {uberdeps/uberdeps {:mvn/version "1.1.4"}}}'';
  uberdeps-script = writeShellScript "bebot-uberdeps.sh" ''
    SRC=$1
    TARGET=$2
    clojure -M -m uberdeps.uberjar --deps-file $SRC/deps.edn --target $TARGET
  '';

in stdenv.mkDerivation {
  name = full-name;
  src = gitignoreSource ./.;
  outputs = [ "lib" ];
  buildInputs = [ clojure ] ++ map (d: d.paths) cljdeps.packages;
  buildPhase = ''
    mkdir $TEMP/build
    cd $TEMP/build
    cp ${uberdeps-edn} .
    ${uberdeps-script} $src ./${jar-name}
  '';
  installPhase = ''
    cp ./target/${jar-name} $out
  '';
}
