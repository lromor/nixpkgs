{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tempo";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "tempo";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-SSAeJOOd282Mnmaj/W5sM8J64qvD9/0SvlbHUtXYYF8=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/tempo-cli"
    "cmd/tempo-query"
    "cmd/tempo-serverless"
    "cmd/tempo-vulture"
    "cmd/tempo"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
    "-X=main.Branch=<release>"
    "-X=main.Revision=${version}"
  ];

  # tests use docker
  doCheck = false;

  meta = with lib; {
    description = "High volume, minimal dependency trace storage";
    license = licenses.asl20;
    homepage = "https://grafana.com/oss/tempo/";
    maintainers = with maintainers; [ willibutz ];
  };
}
