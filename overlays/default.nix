{
  default = final: prev: inputs:
    let
      nurPkgs = removeAttrs (import ../pkgs final prev inputs) [ "callPackage" ];

      pythonOverrides = pyfinal: pyprev:
        removeAttrs (import ../pkgs/python-modules final pyfinal pyprev) [ "callPackage" ];
    in
    nurPkgs // {
      python3 = prev.python3.override { packageOverrides = pythonOverrides; };
      python38 = prev.python38.override { packageOverrides = pythonOverrides; };
      python39 = prev.python39.override { packageOverrides = pythonOverrides; };
      python310 = prev.python310.override { packageOverrides = pythonOverrides; };
      python3Packages = final.python3.pkgs;
      python38Packages = final.python38.pkgs;
      python39Packages = final.python39.pkgs;
      python310Packages = final.python310.pkgs;
    };
}
