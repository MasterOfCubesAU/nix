{ self, inputs, ... }: {
  flake.modules.nixos."users/brandon" = { config, ... }: {
    home-manager.users.brandon = {
      imports = [
        self.modules.homeManager."users/brandon"
        inputs.sops-nix.homeManagerModules.sops
        inputs.steam-config-nix.homeModules.default
      ];
    };
    users.users.brandon = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "rkit"
      ];
    };

    # SMB
    fileSystems."/mnt/brandon" = {
      device = "//192.168.1.178/Brandon";
      fsType = "cifs";
      options = [
        "credentials=${config.home-manager.users.brandon.sops.templates."smb/brandon".path}"
        "uid=1000"
        "gid=100"
        "x-systemd.automount"
        "noauto"
        "_netdev"
      ];
    };
  };

  flake.modules.homeManager."users/brandon" = { config, ... }: {
    sops = {
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = ./secrets.yaml;
      secrets = {
        "smb/brandon" = { };
      };
      templates = {
        "smb/brandon".content = ''
          username=brandon
          password=${config.sops.placeholder."smb/brandon"}
        '';
      };
    };
  };
}
