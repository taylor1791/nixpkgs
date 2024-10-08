{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, mashumaro
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "huum";
  version = "0.7.9";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frwickst";
    repo = "pyhuum";
    rev = "refs/tags/${version}";
    hash = "sha256-wIroT1eMO9VXsPWQkpSBEVN/nR4pg2/Eo4ms81qMaew=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "huum"
  ];

  meta = with lib; {
    description = "Library for Huum saunas";
    homepage = "https://github.com/frwickst/pyhuum";
    changelog = "https://github.com/frwickst/pyhuum/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    broken = versionAtLeast pydantic.version "2";
  };
}
