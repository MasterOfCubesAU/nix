{ self, inputs, ... }:
{
  # System Definition
  flake.nixosConfigurations.tesseract = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.modules.nixos; [
      ./_hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
      tesseract-users
      tesseract-bootloader
      tesseract-networking
      tesseract-graphics
      core
      {
        system.stateVersion = "26.05";
        programs.steam.enable = true;
      }
    ];
  };

  flake.modules.nixos.tesseract-users = {
    home-manager.users.brandon = {
      imports = with self.modules.homeManager; [
        gui
        programming
        terminal
        tooling
        tesseract-configs
      ];
      home.stateVersion = "26.05";
    };
    users.users.brandon = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  flake.modules.nixos.tesseract-bootloader = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };

  flake.modules.nixos.tesseract-networking = {
    networking.hostName = "tesseract";
  };

  flake.modules.nixos.tesseract-graphics =
    { config, pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
      };
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };

  flake.modules.homeManager.tesseract-configs = {
    home.file.".config/kanshi/config".source = ./kanshi.config;
    home.file.".config/sway/config.d/tesseract".source = ./sway.config;
  };
}
