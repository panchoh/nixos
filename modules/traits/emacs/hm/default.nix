{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.emacs;
  emacsCfgDir = "${config.xdg.configHome}/emacs";
  doomCfgDir = "${config.xdg.configHome}/doom";
in {
  options.hm.emacs = {
    enable = lib.mkEnableOption "emacs" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.sessionPath = [
      "${config.xdg.configHome}/emacs/bin"
      "$HOME/.local/bin"
      "$HOME/.local/bin.go"
    ];

    home.activation = {
      cloneDoomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [[ ! -d "${emacsCfgDir}" ]]; then
          verboseEcho Cloning Doom Emacs
          PATH="${config.home.path}/bin:$PATH" run git clone $VERBOSE_ARG --depth=1 --single-branch https://github.com/doomemacs/doomemacs.git "${emacsCfgDir}"
        fi
        mkdir --parents "${doomCfgDir}"
        rmdir --ignore-fail-on-non-empty "${doomCfgDir}"
        if [[ ! -d "${doomCfgDir}" ]]; then
          verboseEcho Cloning Doom Emacs config
          PATH="${config.home.path}/bin:$PATH" run git clone $VERBOSE_ARG git@github.com:panchoh/dotconfig-doom.git "${doomCfgDir}"
          # PATH="${pkgs.git}/bin:$PATH" EMACS="${lib.getExe config.programs.emacs.finalPackage}" run "${emacsCfgDir}"/bin/doom sync
        fi
      '';
    };

    home.packages = with pkgs; [
      (aspellWithDicts (ds: with ds; [en en-computers en-science]))

      findutils
      coreutils
      fd
      shfmt
      shellcheck
      nodejs_20
      python3
      python311Packages.grip
      pipenv
      sqlite

      editorconfig-core-c

      # clang # conflits with gcc, TODO: decide which one to set here
      gcc
      gnumake
      ccls

      gotools
      go-tools
      gopls
      gofumpt
      gomodifytags
      gotests
      gore
      delve
      gdlv

      deadnix
      nil # nix lsp server
      alejandra
      # FIXME: Hack until Doom Emacs can handle alejandra directly
      (stdenv.mkDerivation {
        name = "alejandra-posing-as-nixfmt";
        buildInputs = [alejandra];
        phases = ["installPhase"];
        installPhase = ''
          mkdir -p $out/bin
          cat <<EOF > $out/bin/nixfmt
          #!/bin/sh
          exec ${lib.getExe alejandra} --quiet "\$@"
          EOF
          chmod +x $out/bin/nixfmt
        '';
      })
    ];

    programs.go = {
      enable = true;
      goBin = ".local/bin.go";
    };

    programs.ripgrep = {
      enable = true;
      package = pkgs.ripgrep.override {withPCRE2 = true;};
      arguments = ["--no-config"];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      extraPackages = epkgs: [epkgs.vterm];
    };

    home.sessionVariables = {
      EDITOR = lib.getBin (
        pkgs.writeShellScript "editor" ''
          exec ${lib.getExe' config.programs.emacs.finalPackage "emacsclient"}  \
            --reuse-frame                                                       \
            --alternate-editor=${lib.getExe pkgs.neovim}                        \
          "''${@:---create-frame}"
        ''
      );
    };

    services.emacs = {
      enable = true;
      defaultEditor = false;
      socketActivation.enable = true;
      # startWithUserSession = "graphical";
      client = {
        enable = true;
        arguments = [
          "--reuse-frame"
          "--alternate-editor=nvim"
        ];
      };
    };
  };
}
