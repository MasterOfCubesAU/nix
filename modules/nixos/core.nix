{ self, ... }:
{
  flake.modules.generic.core = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    home-manager.useGlobalPkgs = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  };
  flake.modules.darwin.core = {
    imports = with self.modules.darwin; [
      self.modules.generic.core
      darwin-system
    ];
  };
  flake.modules.nixos.core = {
    imports = with self.modules.nixos; [
      self.modules.generic.core
      audio
      display
    ];

    networking.networkmanager.enable = true;

    time.timeZone = "Australia/Sydney";

    i18n.defaultLocale = "en_AU.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings.main.capslock = "esc";
      };
    };
    services.printing.enable = true;
    services.tailscale.enable = true;
    hardware.bluetooth.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
  };
}
