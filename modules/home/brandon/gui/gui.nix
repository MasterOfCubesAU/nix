{ self, ... }:
{
  flake.modules.homeManager.gui =
    {
      pkgs,
      ...
    }:
    {
      imports = with self.modules.homeManager; [
        noctalia
        sway
        brave
      ];
      home.packages =
        with pkgs;
        [
          vesktop
          spotify
          flameshot
          bruno
          vscode
          bitwarden-desktop
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          crosspipe
          davinci-resolve
        ];
    };
}
