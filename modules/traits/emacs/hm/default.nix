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
          echo 'Now run: doom build'
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

      marksman # markdown language server

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

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      extraPackages = epkgs:
        with epkgs; [
          # nix-ts-mode
          # https://github.com/nix-community/emacs-overlay/issues/341#issuecomment-1605290875
          # treesit-grammars.with-all-grammars
          vterm
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
      ALTERNATE_EDITOR = lib.getExe' pkgs.neovide "neovide";
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
        ];
      };
    };
  };
}
