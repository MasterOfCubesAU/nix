{
  flake.modules.homeManager.rocksmith =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      programs.steam.config = {
        apps."221680" = {
          env.WINEDLLOVERRIDES = "xinput1_3=n,b";
          env.STEAM_COMPAT_MOUNTS = "$XDG_RUNTIME_DIR/secrets.d";
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
