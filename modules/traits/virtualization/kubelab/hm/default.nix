{
  config,
  lib,
  pkgs,
  kubelab,
  ...
}:
let
  cfg = config.traits.hm.kubelab;
in
{
  options.traits.hm.kubelab = {
    enable = lib.mkEnableOption "kubelab" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.stdenvNoCC.mkDerivation rec {
        pname = "kubelab";
        version = kubelab.rev; # Use the commit ID as the version
        src = kubelab;

        buildInputs = with pkgs; [
          ansible
          ansible-lint
          # TODO: vmtools, when refactored into a proper package
        ];

        nativeBuildInputs = [ pkgs.makeWrapper ];

        dontUnpack = true;
        dontPatch = true;
        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          mkdir -p $out/bin
          cp -r $src/bin/cluster_* $out/bin
        '';

        # fixupPhase = ''
        #   for script in $out/bin/vm*; do
        #     substituteInPlace $script --replace sudo run0
        #     wrapProgram $script --prefix PATH : ${lib.makeBinPath buildInputs}
        #   done
        # '';
      })
    ];
  };
}
