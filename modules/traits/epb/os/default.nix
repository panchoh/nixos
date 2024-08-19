{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.os.epb;
  policy =
    if box.isLaptop or false
    then "--turbo-enable 0 power"
    else "performance";
in {
  options.traits.os.epb = {
    enable = lib.mkEnableOption "Performance and Energy Bias Hint (EPB)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    # https://docs.kernel.org/admin-guide/pm/intel_epb.html
    # https://bbs.archlinux.org/viewtopic.php?id=270199
    # https://stackoverflow.com/questions/58243712/how-to-install-systemd-service-on-nixos
    # cat /sys/devices/system/cpu/cpu*/power/energy_perf_bias
    systemd.services.epb = {
      enable = true;
      description = "Run x86_energy_perf_policy at boot";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = "${lib.getExe' pkgs.kmod "modprobe"} msr";
        ExecStart = "${lib.getExe' pkgs.linuxPackages_latest.x86_energy_perf_policy "x86_energy_perf_policy"} ${policy}";
        ExecStartPost = "${lib.getExe' pkgs.kmod "modprobe"} -r msr";
      };
    };
  };
}
