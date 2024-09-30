{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.emacs;
  emacsCfgDir = "${config.xdg.configHome}/emacs";
  doomCfgDir = "${config.xdg.configHome}/doom";
in {
  options.traits.hm.emacs = {
    enable = lib.mkEnableOption "emacs" // {default = box.isStation;};
  };

  config = lib.mkIf cfg.enable {
    home.sessionPath = [
      "${config.xdg.configHome}/emacs/bin"
    ];

    home.activation = {
      cloneDoomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [[ ! -d "${emacsCfgDir}" ]]; then
          verboseEcho Cloning Doom Emacs
          DOOMEMACS=https://github.com/doomemacs/doomemacs.git
          PATH="${config.home.path}/bin:$PATH" run git clone $VERBOSE_ARG --depth=1 --single-branch "$DOOMEMACS" "${emacsCfgDir}"
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
      (pkgs.writeShellApplication {
        name = "doom-wipe-state";
        runtimeInputs = [coreutils];
        text = ''
          echo 'Cleaning most of state; repos and logs preserved:'
          rm -rf "${emacsCfgDir}/.local/{cache,etc,straight/build*}"
          echo 'Now run: doom sync --rebuild --aot'
        '';
      })

      (aspellWithDicts (ds: with ds; [en en-computers en-science]))

      findutils
      coreutils
      fd
      shfmt
      shellcheck
      nodejs_20
      python3
      python312Packages.grip
      pipenv
      sqlite

      editorconfig-core-c

      # clang # conflits with gcc, TODO: decide which one to set here
      gcc
      gnumake
      ccls

      zig
      zls

      pyright

      marksman # markdown language server

      hugo

      dockfmt

      nil # nix language server
      deadnix
      alejandra

      # FIXME: Hack until Doom Emacs can handle `nix fmt` directly
      #
      # Doom Emacs leverages nix-mode.el, which can be tweaked to use a
      # different formatter, but not what parameters to send to it.
      # So we need this wrapper.
      (pkgs.writeShellApplication {
        # name = "nixfmt";
        name = "alejandra-the-quiet";
        runtimeInputs = [alejandra];
        text = ''
          exec alejandra --quiet "$@"
        '';
      })
    ];

    programs.ripgrep = {
      enable = true;
      package = pkgs.ripgrep.override {withPCRE2 = true;};
      arguments = ["--no-config"];
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacs-unstable-pgtk;
      extraPackages = epkgs:
        with epkgs; [
          nix-ts-mode
          vterm
          treesit-grammars.with-all-grammars
        ];
    };

    home.sessionVariables = {
      EDITOR = lib.getBin (
        pkgs.writeShellScript "editor" ''
          exec ${lib.getExe' config.programs.emacs.finalPackage "emacsclient"} \
            --reuse-frame                                                      \
            "$@"
        ''
      );
      ALTERNATE_EDITOR = lib.getExe config.programs.neovide.package;
    };

    services.emacs = {
      enable = false;
      defaultEditor = false;
      socketActivation.enable = false;
      # startWithUserSession = "graphical";
      client = {
        enable = true;
        arguments = [
          "--reuse-frame"
        ];
      };
    };
  };
}
