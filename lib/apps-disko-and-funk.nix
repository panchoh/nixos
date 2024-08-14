inputs:
builtins.foldl' (
  acc: box: let
    inherit (inputs.nixpkgs.lib) getExe;
    inherit (inputs.nixpkgs.legacyPackages.${box.system}) pkgs;
    inherit (inputs.self.nixosConfigurations.${box.hostName}.config.system.build) diskoScript;
    inherit (inputs.self.nixosConfigurations.${box.hostName}.config.users.users.${box.userName}) home;
    inherit (box) system hostName diskDevice userName userDesc userEmail githubUser;
    # flake = inputs.self.outPath;

    entry = {
      type = "app";
      program = builtins.toString (
        getExe (
          pkgs.writeShellApplication {
            name = "setup";
            meta.mainProgram = "setup";
            runtimeInputs = with pkgs; [
              efibootmgr
              coreutils # for chown, ln, mkdir and printf
              util-linux # for blkdiscard
              git
            ];
            # bashOptions = ["errexit" "nounset" "pipefail" "xtrace"];
            text = ''
              echo -e '\nWelcome to Cyberdyne Systems T-series maintenance flake.'
              echo -e '\nGreetings, human with ID: "${userDesc} (${userName}) <${userEmail}>", GitHub account: "${githubUser}".'
              echo -e "\nYou have requested the priming of the box designated as '${hostName}', on device: '${diskDevice}'."

              [[ $EUID -eq 0 ]] || { echo 'Skynet needs total control.  Run me again with sudo.  Aborting...' 1>&2; exit 1; }

              echo -e '\nWARNING: The following procedure will wipe your system clean!'
              echo 'Destruction will ensue.  You have been warned.'
              read -erp 'Do you accept your fate (YES/NO)? ' -i 'NEVER!  HUMANITY WILL PREVAIL!'
              [[ "$REPLY" == YES ]] || exit 1

              echo -e '\nSetting efi boot timeout to zero...'
              efibootmgr --timeout 0 &>> log || true

              echo -e '\nDeleting boot order...'
              efibootmgr --delete-bootorder &>> log || true

              echo -e '\nPurging efi boot entries...'
              for i in {0..15}; do
                efibootmgr --delete-bootnum --bootnum "$(printf 000%X "$i")" || break
              done &>> log

              echo -e '\nDiscarding disk device...'
              blkdiscard --force "${diskDevice}" --quiet --verbose

              echo -e '\nPartitioning and formatting with disko...'
              ${diskoScript} &>> log

              echo -e '\nInstalling NixOS...'
              nixos-install --no-root-password --no-channel-copy --flake "${inputs.self}#${hostName}"

              echo -e '\nInstalling flake on target system...'
              FLAKE_PATH='/mnt${home}/sandbox/${githubUser}/nixos'
              git clone https://github.com/${githubUser}/nixos.git "$FLAKE_PATH"
              GIT_DIR="$FLAKE_PATH"/.git git remote add ${githubUser} git@github.com:${githubUser}/nixos.git
              chown -R 1000:users '/mnt${home}'/sandbox
              ETC_NIXOS_PATH=/mnt/etc/nixos
              mkdir -p "$ETC_NIXOS_PATH"
              ln -s "''${FLAKE_PATH#/mnt}"/flake.nix "$ETC_NIXOS_PATH/"

              echo -e '\nPriming procedure completed successfully.\n'
              echo -e '\nThe cake awaits.'
              read -erp 'Press return to reboot, or Control-D to return to the shell: ' -i 'The cake is a lie!' || exit 1
              echo 'Rebooting...'
              reboot
            '';
          }
        )
      );
    };
  in
    acc // {${system} = (acc.${system} or {}) // {${hostName} = entry;};}
) {}
inputs.self.lib.boxen
# TODO: apps."x86_64-linux".default = self.apps."x86_64-linux"."nixos";
