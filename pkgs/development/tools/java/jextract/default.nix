{ lib
, stdenv
, fetchFromGitHub
, emptyDirectory
, writeText
, makeWrapper
, gradle
, jdk20
, llvmPackages
}:

let
  gradleInit = writeText "init.gradle" ''
    logger.lifecycle 'Replacing Maven repositories with empty directory...'
    gradle.projectsLoaded {
      rootProject.allprojects {
        buildscript {
          repositories {
            clear()
            maven { url '${emptyDirectory}' }
          }
        }
        repositories {
          clear()
          maven { url '${emptyDirectory}' }
        }
      }
    }
    settingsEvaluated { settings ->
      settings.pluginManagement {
        repositories {
          maven { url '${emptyDirectory}' }
        }
      }
    }
  '';
in

stdenv.mkDerivation {
  pname = "jextract";
  version = "unstable-2023-04-14";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jextract";
    rev = "cf3afe9ca71592c8ebb32f219707285dd1d5b28a";
    hash = "sha256-8qRD1Xg39vxtFAdguD8XvkQ8u7YzFU55MhyyJozVffo=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  env = {
    ORG_GRADLE_PROJECT_llvm_home = llvmPackages.libclang.lib;
    ORG_GRADLE_PROJECT_jdk20_home = jdk20;
  };

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --console plain --init-script "${gradleInit}" assemble

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    gradle --console plain --init-script "${gradleInit}" verify
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -D --mode=0444 --target-directory="$out/share/java" \
      ./build/libs/org.openjdk.jextract-unspecified.jar

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper "${jdk20}/bin/java" "$out/bin/jextract" \
      --add-flags "--enable-preview" \
      --add-flags "--class-path $out/share/java/org.openjdk.jextract-unspecified.jar" \
      --add-flags "org.openjdk.jextract.JextractTool"
  '';

  meta = with lib; {
    description = "A tool which mechanically generates Java bindings from a native library headers";
    homepage = "https://github.com/openjdk/jextract";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sharzy ];
  };
}
