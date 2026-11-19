{
  flake.modules.homeManager.rocksmith =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      rocksmithInstallDir = "${config.home.homeDirectory}/.local/share/Steam/steamapps/common/Rocksmith2014";
    in
    {
      programs.steam.config = {
        apps."221680" = {
          env.STEAM_COMPAT_MOUNTS = "$XDG_RUNTIME_DIR/secrets.d";
          dllOverrides = {
            xinput1_3 = "n,b";
          };
          files.game.place = {
            # CDLC
            "D3DX9_42.dll".source = "${
              (pkgs.fetchFromGitHub {
                owner = "Lovrom8";
                repo = "RSCDLCEnabler-TooManyCoresFix";
                rev = "b88101f4e9add056a2df5640705bc8fc31ebf89f";
                sha256 = "sha256-OQc2Ijne2XJWhug5esvF847pznQkTiL8s/gXUkByNi8=";
              })
            }/RSCDLCEnabler/D3DX9_42.dll";
            # RSMods
            "RSMods".source = ./mods/RSMods;
            "RSMods.ini".source = ./mods/RSMods/RSMods.ini;
            "xinput1_3.dll".source = ./mods/RSMods/xinput1_3.dll;
          };
          wrappers = [
            (lib.getExe pkgs.gamescope)
            "-W"
            "2560"
            "-H"
            "1440"
            "-r"
            "180"
            "--"
          ];
        };
        nonSteamApps = {
          "RSMods" = {
            compatTool = "proton_experimental";
            target = "${rocksmithInstallDir}/RSMods/RSMods.exe";
          };
        };
      };
      sops.secrets.rs-input-device = {
      };

      sops.templates."pipeasio-config" = {
        content = ''
          [pipeasio]
          buffer_size=256
          input_device=${config.sops.placeholder.rs-input-device}
          inputs=1
          output_device=
          sample_rate=48000
        '';
        path = "${config.xdg.configHome}/pipeasio/config.ini";
      };
      xdg.configFile."pipeasio/config.ini".force = true;
    };

  flake.modules.nixos.rocksmith = {
    programs.steam.rocksmithPatch.enable = true;
  };
}
