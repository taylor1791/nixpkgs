{ lib
, stdenv
, fetchFromGitHub
, glibcLocales
, installShellFiles
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      # Doesn't work with latest urwid
      urwid = super.urwid.overridePythonAttrs (oldAttrs: rec {
        version = "2.1.2";
        src = fetchFromGitHub {
          owner = "urwid";
          repo = "urwid";
          rev = "refs/tags/${version}";
          hash = "sha256-oPb2h/+gaqkZTXIiESjExMfBNnOzDvoMkXvkZ/+KVwo=";
        };
        doCheck = false;
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "khal";
  version = "0.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = "khal";
    rev = "refs/tags/v${version}";
    hash = "sha256-yI33pB/t+UISvSbLUzmsZqBxLF6r8R3j9iPNeosKcYw=";
  };

  nativeBuildInputs = [
    glibcLocales
    installShellFiles
  ] ++ (with python3.pkgs; [
    setuptools
    setuptools-scm
    sphinx
    sphinxcontrib-newsfeed
  ]);

  propagatedBuildInputs = with py.pkgs;[
    atomicwrites
    click
    click-log
    configobj
    freezegun
    icalendar
    lxml
    pkginfo
    vdirsyncer
    python-dateutil
    pytz
    pyxdg
    requests-toolbelt
    tzlocal
    urwid
  ];

  nativeCheckInputs = with python3.pkgs;[
    freezegun
    hypothesis
    packaging
    pytestCheckHook
    vdirsyncer
  ];

  postInstall = ''
    # shell completions
    installShellCompletion --cmd khal \
      --bash <(_KHAL_COMPLETE=bash_source $out/bin/khal) \
      --zsh <(_KHAL_COMPLETE=zsh_source $out/bin/khal) \
      --fish <(_KHAL_COMPLETE=fish_source $out/bin/khal)

    # man page
    PATH="${python3.withPackages (ps: with ps; [ sphinx sphinxcontrib-newsfeed ])}/bin:$PATH" \
    make -C doc man
    installManPage doc/build/man/khal.1

    # .desktop file
    install -Dm755 misc/khal.desktop -t $out/share/applications
  '';

  doCheck = !stdenv.isAarch64;

  LC_ALL = "en_US.UTF-8";

  disabledTests = [
    # timing based
    "test_etag"
    "test_bogota"
    "test_event_no_dst"
  ];

  meta = with lib; {
    description = "CLI calendar application";
    homepage = "http://lostpackets.de/khal/";
    changelog = "https://github.com/pimutils/khal/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
