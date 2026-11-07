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
        brave
      ];
      home.packages = with pkgs; [
        vesktop
        spotify
        flameshot
        bruno
        vscode
        bitwarden-desktop
      ];
      services.easyeffects.enable = true;
    };
}
