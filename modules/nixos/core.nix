{ self, ... }:
{
  flake.modules.generic.core = { pkgs, ... }: {
    # Nix Settings
    nixpkgs.config = {
      microsoftVisualStudioLicenseAccepted = true;
      allowUnfree = true;
    };

    # Home Manager Global Pkgs
    home-manager.useGlobalPkgs = true;

    # Nix Experimental Features
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Fonts
    fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  };

  flake.modules.darwin.core = {
    imports = [
      self.modules.generic.core
    ];

    # Homebrew
    homebrew = {
      enable = true;
      enableZshIntegration = true;
    };

    # Use TouchID for sudo
    security.pam.services.sudo_local.touchIdAuth = true;
  };

  flake.modules.nixos.core = {
    imports = with self.modules.nixos; [
      self.modules.generic.core
      audio
      display
    ];

    # Virtualisation
    virtualisation.vmVariant = {
      virtualisation = {
        memorySize = 4096;
        cores = 2;
      };
    };

    # Networking
    networking.networkmanager.enable = true;

    # Time Zone
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

    # Keyboard Mapping
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings.main.capslock = "esc";
      };
    };

    # Printing
    services.printing.enable = true;

    # Tailscale
    services.tailscale.enable = true;
    # Bluetooth
    hardware.bluetooth.enable = true;

    # Power Management
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
  };
}
