{ stdenv, lib, fetchFromGitHub, makeWrapper, bundlerEnv }:

stdenv.mkDerivation rec {
  pname = "evil-winrm";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "Hackplayers";
    repo = "evil-winrm";
    rev = "v${version}";
    sha256 = "sha256-8Lyo7BgypzrHMEcbYlxo/XWwOtBqs2tczYnc3+XEbeA=";
  };

  env = bundlerEnv {
    name = pname;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ env.wrappedRuby ];

  installPhase = ''
    mkdir -p $out/bin
    cp evil-winrm.rb $out/bin/evil-winrm
  '';

  meta = with lib; {
    homepage = "https://github.com/Hackplayers/evil-winrm";
    changelog = "https://github.com/Hackplayers/evil-winrm/releases/tag/v${version}";
    description = "WinRM shell for hacking/pentesting";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ elohmeier ];
  };
}
