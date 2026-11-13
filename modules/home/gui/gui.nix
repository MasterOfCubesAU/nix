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
      home.packages = with pkgs; [
        vesktop
        spotify
        flameshot
        bruno
        vscode
        bitwarden-desktop
        crosspipe
      ];
      services.easyeffects.enable = true;
      services.kanshi.enable = true;
    };
}
