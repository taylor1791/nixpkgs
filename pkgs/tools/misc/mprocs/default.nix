{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mprocs";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = pname;
    rev = "71b65984dba7c768b383544cd7829ab099b965a9";
    sha256 = "sha256-uwr+cHenV38IsTEW/PQB0kCDsyahiQrBh4s8v8SyEn8=";
  };

  doCheck = false;

  cargoSha256 = "sha256-H9oHppG7sew/3JrUtWq2Pip1S9H36qYeHu6x/sPfwV0=";

  meta = with lib; {
    description = "A TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage thehedgeh0g ];
  };
}
