{
  default = final: prev: inputs:
    let
      nurPkgs = removeAttrs (import ../pkgs final prev inputs) [ "callPackage" ];
    in
    nurPkgs // { };
}
