{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, src
, python
, pkg-config
, click
, python-dateutil
}:

buildPythonPackage rec {
  pname = "beancount3";
  version = "master";

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beancount";
    rev = "master";
    sha256 = "sha256-j+iDkno+FNyMG7kuykGJedKOfqO7jXEoQtcazqo3z/8=";
  };

  propagatedBuildInputs = [
    click
    python-dateutil
  ];

  buildPhase = ''
     ${python.interpreter} setup.py build_ext --inplace
    ${python.interpreter} setup.py bdist_wheel
  '';
  #nativeBuildInputs = [ bash pkg-config ];
  doCheck = false;

  #checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Beancount: Double-Entry Accounting from Text Files.";
    homepage = "https://github.com/beancount/beancount";
    maintainers = with maintainers; [ polarmutex ];
  };
}
