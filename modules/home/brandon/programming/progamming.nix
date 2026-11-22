{ self, ... }:
{
  flake.modules.homeManager.programming =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = with self.modules.homeManager; [
        git
      ];

      home.packages = lib.mkMerge [
        (with pkgs; [
          uv
          gcc
          nodejs_22
          cargo
          rustc
          rust-analyzer
          rustfmt
          nixfmt
        ])
        (lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) [
          pkgs.gdb
        ])
      ];

      home.sessionVariables.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    };
}
