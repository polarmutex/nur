{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, typing-extensions
, src
, beancount
, matplotlib
, pandas
, scipy
}:

buildPythonPackage rec {
  pname = "beangrow";
  version = "master";
  format = "pyproject";

  inherit src;

  propagatedBuildInputs = [
    beancount
    matplotlib
    pandas
    scipy
  ];

  #checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Returns calculations on portfolios in Beancount";
    homepage = "https://github.com/beancount/beangrow";
    maintainers = with maintainers; [ polarmutex ];
  };
}
