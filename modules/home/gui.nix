{
  flake.modules.homeManager.gui =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        vesktop
        spotify
        brave
        flameshot
        bruno
        vscode
        bitwarden-desktop
      ];
    };
}
