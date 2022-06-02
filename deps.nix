# generated by clj2nix-1.1.0-rc
{ fetchMavenArtifact, fetchgit, lib }:

let repos = [
        "https://repo1.maven.org/maven2/"
        "https://repo.clojars.org/" ];

  in rec {
      makePaths = {extraClasspaths ? []}:
        if (builtins.typeOf extraClasspaths != "list")
        then builtins.throw "extraClasspaths must be of type 'list'!"
        else (lib.concatMap (dep:
          builtins.map (path:
            if builtins.isString path then
              path
            else if builtins.hasAttr "jar" path then
              path.jar
            else if builtins.hasAttr "outPath" path then
              path.outPath
            else
              path
            )
          dep.paths)
        packages) ++ extraClasspaths;
      makeClasspaths = {extraClasspaths ? []}:
       if (builtins.typeOf extraClasspaths != "list")
       then builtins.throw "extraClasspaths must be of type 'list'!"
       else builtins.concatStringsSep ":" (makePaths {inherit extraClasspaths;});
      packageSources = builtins.map (dep: dep.src) packages;
      packages = [
  rec {
    name = "clojure/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "clojure";
      groupId = "org.clojure";
      sha512 = "1925300a0fe4cc9fc3985910bb04ae65a19ce274dacc5ec76e708cfa87a7952a0a77282b083d0aebb2206afff619af73a57f0d661a3423601586f0829cc7956b";
      version = "1.11.1";
      
    };
    paths = [ src ];
  }

  rec {
    name = "javax.activation-api/javax.activation";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "javax.activation-api";
      groupId = "javax.activation";
      sha512 = "8ee0db43ae402f0079a836ef2bff5d15160e3ff9d585c3283f4cf474be4edd2fcc8714d8f032efd72cae77ec5f6d304fc24fa094d9cdba5cf72966cc964af6c9";
      version = "1.2.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "tools.analyzer/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "tools.analyzer";
      groupId = "org.clojure";
      sha512 = "c51752a714848247b05c6f98b54276b4fe8fd44b3d970070b0f30cd755ac6656030fd8943a1ffd08279af8eeff160365be47791e48f05ac9cc2488b6e2dfe504";
      version = "1.1.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "commons-lang3/org.apache.commons";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "commons-lang3";
      groupId = "org.apache.commons";
      sha512 = "fbdbc0943cb3498b0148e86a39b773f97c8e6013740f72dbc727faeabea402073e2cc8c4d68198e5fc6b08a13b7700236292e99d4785f2c9989f2e5fac11fd81";
      version = "3.12.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jersey-common/org.glassfish.jersey.core";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jersey-common";
      groupId = "org.glassfish.jersey.core";
      sha512 = "8348a70ed563002fd147a1c1089005024090a2f01f7265814298ab6dc7c414a3a8885dd9d384a64b5ae64e7650f20f0c4ba068fb5122da11e8f5178a813ed42d";
      version = "3.0.3";
      
    };
    paths = [ src ];
  }

  rec {
    name = "core.specs.alpha/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "core.specs.alpha";
      groupId = "org.clojure";
      sha512 = "f521f95b362a47bb35f7c85528c34537f905fb3dd24f2284201e445635a0df701b35d8419d53c6507cc78d3717c1f83cda35ea4c82abd8943cd2ab3de3fcad70";
      version = "0.2.62";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jackson-module-jaxb-annotations/com.fasterxml.jackson.module";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jackson-module-jaxb-annotations";
      groupId = "com.fasterxml.jackson.module";
      sha512 = "6ff95c56dd80ec5dda127ada204da0cb592edea60208d0e868fe8d281094c514a37f86ce34fdf621694843ae2ccc67f8d5d8f23690def0b5f8bb967a7a06cebc";
      version = "2.12.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jackson-databind/com.fasterxml.jackson.core";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jackson-databind";
      groupId = "com.fasterxml.jackson.core";
      sha512 = "989ad045d6ba00146996068f6acee4b90fc5cdb7ee4d4c71a321c0ae06fcc32116879353585651d13634007e434fe1c0a51f6ba086161e1b6a2fdf037b2a8354";
      version = "2.12.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "spec.alpha/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "spec.alpha";
      groupId = "org.clojure";
      sha512 = "ddfe4fa84622abd8ac56e2aa565a56e6bdc0bf330f377ff3e269ddc241bb9dbcac332c13502dfd4c09c2c08fe24d8d2e8cf3d04a1bc819ca5657b4e41feaa7c2";
      version = "0.3.218";
      
    };
    paths = [ src ];
  }

  rec {
    name = "hk2-utils/org.glassfish.hk2";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "hk2-utils";
      groupId = "org.glassfish.hk2";
      sha512 = "5939e695b9ead25fb27fa443ec6a2f4e50da722cd230cf1b8127f15bffbdd8a7aa2cb59fe985933fd66823a4105e1e52906115ddf83a38d446b05f8141096e1b";
      version = "3.0.1";
      
    };
    paths = [ src ];
  }

  rec {
    name = "opengraph4j/net.bis5.opengraph4j";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "opengraph4j";
      groupId = "net.bis5.opengraph4j";
      sha512 = "3fcab6dd4264dad5c4a12c13ba82341652c302bf1061185b68053f2e6c5f05466ed156116be6f3e97928cc4223b104be31fbcf3c4db50c373c9825a81a3e892c";
      version = "0.1.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "tools.analyzer.jvm/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "tools.analyzer.jvm";
      groupId = "org.clojure";
      sha512 = "36ad50a7a79c47dea16032fc4b927bd7b56b8bedcbd20cc9c1b9c85edede3a455369b8806509b56a48457dcd32e1f708f74228bce2b4492bd6ff6fc4f1219d56";
      version = "1.2.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "aopalliance-repackaged/org.glassfish.hk2.external";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "aopalliance-repackaged";
      groupId = "org.glassfish.hk2.external";
      sha512 = "3668f73df26a036cb325e4de858e4b711b2e88b79504bc5a1fe64be716523951614645c8b11dcc476ad8fabd1281dc5121c95578a32dbc7a371a5d09b65f739c";
      version = "3.0.1";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jackson-core/com.fasterxml.jackson.core";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jackson-core";
      groupId = "com.fasterxml.jackson.core";
      sha512 = "4815cd65a44ac49e486c0aef639c3ee55b7d939b78bf6409a762f9d476279d9015d4b89b4a9d3a906b5e2cf512c9094c6450b7e1f03404e94d36fe2db287ea2c";
      version = "2.12.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "asm/org.ow2.asm";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "asm";
      groupId = "org.ow2.asm";
      sha512 = "876eac7406e60ab8b9bd6cd3c221960eaa53febea176a88ae02f4fa92dbcfe80a3c764ba390d96b909c87269a30a69b1ee037a4c642c2f535df4ea2e0dd499f2";
      version = "9.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jersey-media-multipart/org.glassfish.jersey.media";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jersey-media-multipart";
      groupId = "org.glassfish.jersey.media";
      sha512 = "bd0a7e6179ea72cd46938797e695a6a5b2bd7bd5be807062718c26c191a19820355b96f28fddcb6493e672b98ffa8aa9b0e1a0259a71c6510b9253224c8f03f3";
      version = "3.0.3";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jakarta.annotation-api/jakarta.annotation";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jakarta.annotation-api";
      groupId = "jakarta.annotation";
      sha512 = "7cd34890b93f32f8c1956aec4825ffcfa5151cc6de62930a46fc4c6b75182a8579dcc79ba0fa2fec12fe19d9301891130b610df374ab105e61a0991e15b5a006";
      version = "2.0.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jackson-annotations/com.fasterxml.jackson.core";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jackson-annotations";
      groupId = "com.fasterxml.jackson.core";
      sha512 = "5011e9946045bfe23e2e8f06c50d0b325216fea735a3e83ff8de44650e03b03633463196e4cacd101a7ca4ecf1c1074c4d4ef6c5d21c3b4196cb395ac60993ab";
      version = "2.12.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "javassist/org.javassist";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "javassist";
      groupId = "org.javassist";
      sha512 = "638d2ed77ae1f34dd57f6aa653635a77d8477b3e99f64343ea5eafcec49ebac13250639924c47c83246890bd8988d92c30785ed8854c8a101138c410657cb944";
      version = "3.25.0-GA";
      
    };
    paths = [ src ];
  }

  rec {
    name = "hk2-api/org.glassfish.hk2";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "hk2-api";
      groupId = "org.glassfish.hk2";
      sha512 = "7fc8efbc8eb67dc3eb85f152286f5e66e1924099e068ebea4af7051d658ea2a3fb3661bb30814b7eddd4189c32b98fee0bb56a5b212eed30ac666f70dfa57578";
      version = "3.0.1";
      
    };
    paths = [ src ];
  }

  rec {
    name = "mattermost-models/net.bis5.mattermost4j";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "mattermost-models";
      groupId = "net.bis5.mattermost4j";
      sha512 = "01b34a14ddd56856f8d91a1cd6da650d4f93aa15e43e9e71dc7cb30a97ea9ba64a26323be2b15ad98b52622dc4b9aeb2cb41955c4b5a54b4a360d33ed1eab178";
      version = "0.24.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jersey-hk2/org.glassfish.jersey.inject";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jersey-hk2";
      groupId = "org.glassfish.jersey.inject";
      sha512 = "e4c1f122d8dd063316afeedb0f21221263aea7122b4e687a6cf969661b93dbb6a2c2545207f41c45e08aaed7efc7551478a39ddec890c07bf35dbdca428c5d98";
      version = "3.0.3";
      
    };
    paths = [ src ];
  }

  rec {
    name = "mattermost4j-core/net.bis5.mattermost4j";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "mattermost4j-core";
      groupId = "net.bis5.mattermost4j";
      sha512 = "fc9c16827631ec376a1701a330b670717b5ef415256385d12c9e91a618aefc4f0be9ca066e691a5ae66ca85cce17058e39cbba00218c5546a0935f396e1b8670";
      version = "0.24.0";
      
    };
    paths = [ src ];
  }

  (rec {
    name = "org.fudo/fudo-clojure";
    src = fetchgit {
      name = "fudo-clojure";
      url = "https://git.fudo.org/fudo-public/fudo-clojure.git";
      rev = "2d9303f55f7eac9c2f8989e9a0dde3dc97811220";
      sha256 = "1v57m9gcn92bd3xp5pkanf7wxvbq5hrpl6ddj7w2frqcb9f19x4g";
    };
    paths = map (path: src + path) [
      "/src"
    ];
  })

  rec {
    name = "hk2-locator/org.glassfish.hk2";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "hk2-locator";
      groupId = "org.glassfish.hk2";
      sha512 = "1edfd0eb28a0b60a3f1d44dc5604a4681e3bda72cef0e8a953df419e84b9938051d48e3a471e3abf56c0107ddf95ca86d6c99cb063a2a14b1ba1be78a2b1f5fe";
      version = "3.0.1";
      
    };
    paths = [ src ];
  }

  rec {
    name = "core.match/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "core.match";
      groupId = "org.clojure";
      sha512 = "52ada3bbe73ed1b429be811d3990df0cdb3e9d50f2a6c92b70d490a8ea922d4794da93c3b7487653f801954fc599704599b318b4d7926a9594583df37c55e926";
      version = "1.0.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "tools.reader/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "tools.reader";
      groupId = "org.clojure";
      sha512 = "3481259c7a1eac719db2921e60173686726a0c2b65879d51a64d516a37f6120db8ffbb74b8bd273404285d7b25143ab5c7ced37e7c0eaf4ab1e44586ccd3c651";
      version = "1.3.6";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jersey-client/org.glassfish.jersey.core";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jersey-client";
      groupId = "org.glassfish.jersey.core";
      sha512 = "f928076b42ee7da8b81d5c85b58074ad668c1c6554208fd6e3d47b13e99133dc4dd97c5390572e298a67635b89e71c27c0314639bf3c96ba482efeb16533f38b";
      version = "3.0.3";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jersey-media-json-jackson/org.glassfish.jersey.media";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jersey-media-json-jackson";
      groupId = "org.glassfish.jersey.media";
      sha512 = "73e7dd4b8cfad62b7a05984597c6af3a7f5ec0187a7f84abd65c7db9b8147b57ee0cbdb0d46da8120e411958aca1d5f04582e87c385b438b9f1d6ac9a91676a1";
      version = "3.0.3";
      
    };
    paths = [ src ];
  }

  rec {
    name = "osgi-resource-locator/org.glassfish.hk2";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "osgi-resource-locator";
      groupId = "org.glassfish.hk2";
      sha512 = "4d84983a9b1c72f58661b576c78ca456a2106602c2ad211cd7e72d94464c8774173b34a35629c507c7c84c982f1de0c9bf48352458e8480be5f874d20d6e69a3";
      version = "1.0.3";
      
    };
    paths = [ src ];
  }

  rec {
    name = "core.memoize/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "core.memoize";
      groupId = "org.clojure";
      sha512 = "67196537084b7cc34a01454d2a3b72de3fddce081b72d7a6dc1592d269a6c2728b79630bd2d52c1bf2d2f903c12add6f23df954c02ef8237f240d7394ccc3dde";
      version = "1.0.253";
      
    };
    paths = [ src ];
  }

  rec {
    name = "data.priority-map/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "data.priority-map";
      groupId = "org.clojure";
      sha512 = "bb8bc5dbfd3738c36b99a51880ac3f1381d6564e67601549ef5e7ae2b900e53cdcdfb8d0fa4bf32fb8ebc4de89d954bfa3ab7e8a1122bc34ee5073c7c707ac13";
      version = "1.1.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jersey-entity-filtering/org.glassfish.jersey.ext";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jersey-entity-filtering";
      groupId = "org.glassfish.jersey.ext";
      sha512 = "06a691359c8cf74f126a85f44f29c2c011fb9284ea6e67231011f515b4286b8c15a6f4c4e700367b9564a2d205c444f40a34d23555320d5c3ed5c87968f9bd83";
      version = "3.0.3";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jakarta.ws.rs-api/jakarta.ws.rs";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jakarta.ws.rs-api";
      groupId = "jakarta.ws.rs";
      sha512 = "25a57149d3b5b57d21ad7b97d5c293adb549b363fb9c22f5d894adab174cd3019886cfa2b8425b67644b12769075fd891352c5230b66846c9bbcd26bc98dc3a9";
      version = "3.0.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "core.cache/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "core.cache";
      groupId = "org.clojure";
      sha512 = "0a07ceffc2fa3a536b23773eefc7ef5e1108913b93c3a5416116a6566de76dd5c218f3fb0cc19415cbaa8843838de310b76282f20bf1fc3467006c9ec373667e";
      version = "1.0.225";
      
    };
    paths = [ src ];
  }

  rec {
    name = "mimepull/org.jvnet.mimepull";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "mimepull";
      groupId = "org.jvnet.mimepull";
      sha512 = "7a9e6946db77a24c6c78afa2cf1173006742fb7caaec94bc27510b60d731eb6f8fe1395eb31ab52854aa3479ba9258656986e4cc7009f1e0c56533fa9e22244f";
      version = "1.9.13";
      
    };
    paths = [ src ];
  }

  rec {
    name = "core.async/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "core.async";
      groupId = "org.clojure";
      sha512 = "160a77da25382d7c257eee56cfe83538620576a331e025a2d672fc26d9f04e606666032395f3c2e26247c782544816a5862348f3a921b1ffffcd309c62ac64f5";
      version = "1.5.648";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jaxb-api/javax.xml.bind";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jaxb-api";
      groupId = "javax.xml.bind";
      sha512 = "93a47b245ab830d664a48c9d14e86198a38809ce94f72ca66b3d68746ae1d7b902f6fef2d1ac1a92c01701549ae80a07db69bd822ffd831a95d8dbffad435790";
      version = "2.3.1";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jakarta.inject-api/jakarta.inject";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "jakarta.inject-api";
      groupId = "jakarta.inject";
      sha512 = "5512882113f8dcb70b087f01e3c11d7d3d505c1671bee6dc47208014599d7830d6f184d249b9db72b351c05dd33259c821b80b784c7b3b6e961eeb03a689644b";
      version = "2.0.0";
      
    };
    paths = [ src ];
  }

  ];
  }
  