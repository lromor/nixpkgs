{ lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_6,
  jdk,
  git,
}:
buildBazelPackage rec {
  pname = "bant";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "bant";
    rev = "v${version}";
    hash = "sha256-tEzZto8ovr+TEtcSH2jc61/ler0L3mSsVKu2If4Zs10=";
  };

  fetchConfigures = true;
  fetchAttrs = {
    sha256 = "sha256-6EJIj0gkoneRjfSqgyCUz0niNWas3N3NdrzETWJ8HRY=";
    bazelTargets = [ "//bant:bant" ];
  };

  nativeBuildInputs = [
    jdk
    git
  ];
  bazel = bazel_6;
  bazelBuildFlags = [ "-c opt --nofetch" ];
  bazelTestTargets = [ "//..." ];
  bazelTargets = ["//bant:bant"];

  buildAttrs = {
    installPhase = ''
      install -D --strip bazel-bin/bant/bant "$out/bin/bant"
    '';
  };

  postPatch = ''
    rm -f .bazelversion
    patchShebangs scripts/create-workspace-status.sh
  '';

  meta = with lib; {
    description = "Bazel/Build Analysis and Navigation Tool";
    homepage = "http://bant.build/";
    license = licenses.asl20;
    maintainers = with maintainers; [ hzeller ];
    platforms = platforms.all;
  };
}
