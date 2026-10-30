{ self, ... }:
{
  flake.modules.homeManager.gui =
    {
      pkgs,
      ...
    }:
    {
      imports = with self.modules.homeManager; [
        sway
      ];
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
