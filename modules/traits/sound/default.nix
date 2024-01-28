{
  config,
  lib,
  ...
}: let
  cfg = config.traits.sound;
in {
  options.traits.sound = {
    enable = lib.mkEnableOption "sound" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
}
