pkgs: final: prev:

with final;

let
  callPackage = pkgs.newScope final;
in
{
  inherit callPackage;

  beancount3 = callPackage ./beancount3 { };

  beangrow = callPackage ./beangrow { };
}
