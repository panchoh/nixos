{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.sound;
in {
  options.traits.sound = {
    enable = lib.mkEnableOption "sound" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    users.users.${box.userName or "alice"}.extraGroups = ["audio"];
    sound.enable = false;
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
