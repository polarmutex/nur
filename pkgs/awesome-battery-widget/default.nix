{ lib
, stdenv
, toLuaModule
, lua
, src
}:

toLuaModule (stdenv.mkDerivation rec {
  name = "awesome-battery-widget-${version}";
  version = "master";

  inherit src;

  buildInputs = [ lua ];

  installPhase = ''
    mkdir -p $out/lib/lua/${lua.luaversion}/
    cp -r . $out/lib/lua/${lua.luaversion}/awesome-battery-widget/
    printf "package.path = '$out/lib/lua/${lua.luaversion}/?/init.lua;' ..  package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${lua.luaversion}/awesome-battery-widget.lua
  '';

  meta = with lib; {
    description = "A UPowerGlib based battery widget for the Awesome WM with a basic widget template mechanism! battery";
    homepage = "https://github.com/Aire-One/awesome-battery_widget";
    license = licenses.mit;
    maintainers = with maintainers; [ polarmutex ];
  };
})
