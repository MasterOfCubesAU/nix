{ inputs, ... }:
{
  flake.modules.nixos.display = { pkgs, ... }: {
    imports = [ inputs.noctalia.nixosModules.default ];
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = [ "--unsupported-gpu" ];
    };

    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
    services.displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        cursor.size = 24;
        keyboard.layout = "us";
      };
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };
    };

    services.kanshi.enable = true;
  };
}
