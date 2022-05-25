{ lib
, stdenv
, toLuaModule
, lua
, src
}:

toLuaModule (stdenv.mkDerivation rec {
  name = "rubato-${version}";
  version = "master";

  inherit src;

  buildInputs = [ lua ];

  installPhase = ''
    mkdir -p $out/lib/lua/${lua.luaversion}/
    cp -r . $out/lib/lua/${lua.luaversion}/rubato/
    printf "package.path = '$out/lib/lua/${lua.luaversion}/?/init.lua;' ..  package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${lua.luaversion}/rubato.lua
  '';

  meta = with lib; {
    description = "Create smooth animations with a slope curve for awesomeWM";
    homepage = "https://github.com/andOrlando/rubato";
    license = licenses.mit;
    maintainers = with maintainers; [ polarmutex ];
  };
})
