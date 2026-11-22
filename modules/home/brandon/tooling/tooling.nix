{
  flake.modules.homeManager.tooling =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        xsel
        xclip
        kubectl
        kubectx
        unzip
        killall
        wget
        file
        tldr
        jq
        bat
        ffmpeg
      ];
    };
}
