{ self, inputs, ... }:
{
  # System Definition
  flake.nixosConfigurations.deck = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.modules.nixos; [
      # Hardware Configuration
      ./_hardware-configuration.nix

      # Flake Input modules
      inputs.jovian.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.steam-config-nix.nixosModules.default

      # Users
      self.modules.nixos."users/brandon"

      # User Modules
      deck-core
    ];
  };

  flake.modules.nixos.deck-core = { lib, ... }: {
    imports = with self.modules.nixos; [ core ];

    # System Version
    system.stateVersion = "26.11";

    # User Definition
    home-manager.users.brandon = {
      imports = with self.modules.homeManager; [
        deck-core
        gui
      ];
    };

    # Display
    services.displayManager.noctalia-greeter.enable = lib.mkForce false;

    # Bootloader
    boot = {
      plymouth.enable = true;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };
      consoleLogLevel = 3;
      kernelParams = [
        "quiet"
        "rd.udev.log_level=3"
        "rd.systemd.show_status=auto"
      ];
    };

    # Deck Config
    jovian = {
      devices.steamdeck.enable = true;
      hardware = {
        has.amd.gpu = true;
        amd.gpu.enableBacklightControl = true;
      };
      steam = {
        enable = true;
        autoStart = true;
        user = "brandon";
        desktopSession = "sway";
      };
      decky-loader = {
        enable = true;
      };
    };

    # Networking
    networking.hostName = "deck";

    # Services
    services.openssh.enable = true;
  };

  flake.modules.homeManager.deck-core = { pkgs, lib, ... }: {
    # Home State Version
    home.stateVersion = "26.05";

    # Steam Apps
    programs.steam.config = {
      enable = true;
      nonSteamApps = {
        "Vesktop" = {
          target = "${lib.getExe pkgs.vesktop}";
        };
        "YouTube" = {
          target = "${lib.getExe pkgs.firefox}/bin/firefox --kiosk https://youtube.com";
        };
      };
    };
  };
}
