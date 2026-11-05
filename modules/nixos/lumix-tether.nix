{
  flake.modules.nixos.lumix-tether =
    { config, pkgs, ... }:
    let
      lumix-tether = pkgs.writeShellScript "lumix-tether" ''
        set -o pipefail
        ${pkgs.gphoto2}/bin/gphoto2 --stdout --capture-movie \
          | ${pkgs.ffmpeg}/bin/ffmpeg -loglevel error -i - \
              -vcodec rawvideo -pix_fmt yuv420p -f v4l2 /dev/video10
      '';
    in
    {
      boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      boot.kernelModules = [ "v4l2loopback" ];
      boot.extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=10 card_label="Lumix S5ii" exclusive_caps=1
      '';

      services.udev.packages = [ pkgs.libgphoto2 ];

      environment.systemPackages = with pkgs; [
        gphoto2
        ffmpeg
        v4l-utils
      ];

      systemd.user.services.lumix-tether = {
        description = "Tethering program to expose a Lumix camera as a webcam device.";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = lumix-tether;
          Restart = "always";
          RestartSec = 3;
        };
      };
    };
}
