{
  config,
  lib,
  pkgs,
  nix-doom-emacs-unstraightened,
  doom-config,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.doom-emacs;
in
{
  imports = [
    nix-doom-emacs-unstraightened.homeModule
  ];

  options.traits.hm.doom-emacs = {
    enable = lib.mkEnableOption "Doom Emacs" // {
      default = box.isStation;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.doom-emacs = {
      enable = true;
      doomDir = doom-config;
      emacs = pkgs.emacs-unstable-pgtk;
      experimentalFetchTree = true;
      provideEmacs = false;

      extraPackages =
        epkgs: with epkgs; [
          eglot-booster
          nix-ts-mode
          vterm
          treesit-grammars.with-all-grammars
        ];
    };

    programs.fd.enable = true;

    programs.ripgrep = {
      enable = true;
      package = pkgs.ripgrep.override { withPCRE2 = true; };
      arguments = [ "--no-config" ];
    };

    home.packages = with pkgs; [
      (aspellWithDicts (
        ds: with ds; [
          en
          en-computers
          en-science
        ]
      ))

      (writeShellApplication {
        name = "doom-pristine";
        runtimeInputs = [ coreutils ];
        text = ''
          echo 'Cleaning Doom state…'
          rm -rfv ~/.cache/doom ~/.local/state/doom ~/.local/share/doom
        '';
      })

      nerd-fonts.symbols-only
      emojione
      twemoji-color-font

      emacs-lsp-booster

      findutils
      coreutils
      ddate
      shfmt
      shellcheck
      nodejs_20
      python3
      pipenv
      sqlite

      editorconfig-core-c

      # clang # conflits with gcc, TODO: decide which one to set here
      gcc
      gnumake
      ccls

      zig
      zls

      graphviz

      pyright

      go-grip
      marksman # markdown language server

      hugo

      dockfmt

      semgrep

      bash-language-server
      yaml-language-server

      nil # nix language server
      nixd
      deadnix

      nixpkgs-review
      nix-output-monitor
      nix-fast-build
    ];

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

    # TODO: enable this, but also take care of `config.doom-emacs.provideEmacs`
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
