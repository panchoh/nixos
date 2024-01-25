{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.emacs;
in {
  options.hm.emacs = {
    enable = lib.mkEnableOption "emacs";
  };

  config = lib.mkIf cfg.enable {
    home.sessionPath = [
      "${config.xdg.configHome}/emacs/bin"
      "$HOME/.local/bin"
      "$HOME/.local/bin.go"
    ];

    home.activation = {
      DoomEmacsAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [[ ! -d "${config.xdg.configHome}"/emacs ]]; then
          run ${lib.getExe pkgs.git} clone $VERBOSE_ARG --depth=1 --single-branch https://github.com/doomemacs/doomemacs.git "${config.xdg.configHome}"/emacs
        fi
        if [[ ! -d "${config.xdg.configHome}"/doom ]]; then
          run ${lib.getExe pkgs.git} clone $VERBOSE_ARG https://github.com/panchoh/dotconfig-doom.git "${config.xdg.configHome}"/doom
          # PATH="${pkgs.git}/bin:$PATH" EMACS="${lib.getExe config.programs.emacs.finalPackage}" run "${config.xdg.configHome}"/emacs/bin/doom sync
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
      startWithUserSession = "graphical";
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
