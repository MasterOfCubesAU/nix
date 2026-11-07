{ inputs, moduleWithSystem, ... }:
{
  flake.modules.nixos.display = moduleWithSystem (
    { self', ... }: { pkgs, ... }: {
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

      xdg.portal = {
        enable = true;
        wlr = {
          enable = true;
          settings.screencast = {
            chooser_type = "simple";
            chooser_cmd = "${self'.packages.wlr-chooser}/bin/wlr-chooser";
          };
        };
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.sway = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
          "org.freedesktop.impl.portal.Inhibit" = "none";
        };
      };
    }
  );
}
