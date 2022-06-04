{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
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

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = pname;
    rev = "master";
    sha256 = "sha256-rqLeiguJRES/uJZu0kzDagEdHPcMGQS2Neci32EpBVI=";
  };

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
