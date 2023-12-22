{ python3Packages, ... }:

with python3Packages;
buildPythonApplication {
  pname = "<name>";
  version = "0.1.0";
  pyproject = true;
  nativeBuildInputs = [
    more-itertools
    setuptools
    wheel
  ];
  propagatedBuildInputs = [
  ];
  src = ./.;
}

