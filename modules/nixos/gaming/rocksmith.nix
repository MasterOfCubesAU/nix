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
      sops.secrets.rs-input-device = { };
      sops.templates."pipeasio-config" = {
        content = builtins.readFile config.xdg.configFile."pipeasio/config.ini".source + ''
          input_device=${config.sops.placeholder.rs-input-device}
        '';
        path = "${config.xdg.configHome}/pipeasio/config.ini";
      };
    };

  flake.modules.nixos.rocksmith = {
    programs.steam.rocksmithPatch.enable = true;
  };
}
