{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.yazi = pkgs.symlinkJoin {
        name = "yazi";
        paths = [ pkgs.yazi ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          for prog in yazi ya; do
            wrapProgram "$out/bin/$prog" \
              --set YAZI_CONFIG_HOME ${./config}
          done
        '';
      };
    };
}
