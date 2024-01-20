{
  config,
  lib,
  ...
}: let
  cfg = config.traits.sound;
in {
  options.traits.sound.enable = lib.mkEnableOption "sound";

  config = lib.mkIf cfg.enable {
    sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
}
