{
  flake.modules.nixos.smb = { config, ... }: {
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
}
