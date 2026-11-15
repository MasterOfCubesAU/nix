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
      sops.secrets.rs-input-device = {
      };

      # TODO: This makes the audio choppy for some reason. Use Crosspipe to route input device for now
      # sops.templates."pipeasio-config" = {
      #   content = ''
      #     [pipeasio]
      #     buffer_size=256
      #     input_device=${config.sops.placeholder.rs-input-device}
      #     inputs=1
      #     output_device=
      #     sample_rate=48000
      #   '';
      #   path = "${config.xdg.configHome}/pipeasio/config.ini";
      # };
      xdg.configFile."pipeasio/config.ini".force = true;
    };

  flake.modules.nixos.rocksmith = {
    programs.steam.rocksmithPatch.enable = true;
  };
}
