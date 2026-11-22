{ self, ... }: {
  flake.modules.nixos.audio = {
    home-manager.sharedModules = with self.modules.homeManager; [ audio ];
    programs.dconf.enable = true;
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  flake.modules.homeManager.audio = {
    services.easyeffects.enable = true;
  };
}
