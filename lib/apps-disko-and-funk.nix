flake:
let
  inherit (flake.inputs.nixpkgs.lib.meta) getExe;
  inherit (flake.inputs.nixpkgs.lib.attrsets) listToAttrs nameValuePair;

  mkApp =
    box:
    let
      inherit (flake.inputs.nixpkgs.legacyPackages.${box.system}) pkgs;
      inherit (flake.nixosConfigurations.${box.hostName}.config.system.build)
        destroyFormatMount
        ;
      inherit (flake.nixosConfigurations.${box.hostName}.config.users.users.${box.userName})
        home
        ;
    in
    {
      type = "app";
      meta.description = "Fresh install of NixOS.";
      program = toString (
        getExe (
          pkgs.writeShellApplication {
            name = "setup";
            meta.mainProgram = "setup";
            runtimeInputs = with pkgs; [
              efibootmgr
              coreutils # for tee, chown, ln, mkdir and printf
              util-linux # for blkdiscard
              git
            ];
            # bashOptions = ["errexit" "nounset" "pipefail" "xtrace"];
            # bashOptions = ["errexit" "nounset" "pipefail" "verbose"];
            text = ''
              [[ $EUID -eq 0 ]] || { echo 'Skynet will accept no less than total control.  Execute with super user privileges.' && exit 1; }

              # Initialize logging
              readonly LOGFILE=disko-and-funk.log
              exec 1> >(tee -a "$LOGFILE")
              exec 2> >(tee -a "$LOGFILE" >&2)

              echo -e '\nWelcome to Cyberdyne Systems T-series maintenance flake.'
              echo -e '\nGreetings, human with ID: "${box.userDesc} (${box.userName}) <${box.userEmail}>", GitHub account: "${box.githubUser}".'
              echo -e "\nYou have requested the priming of the box designated as '${box.hostName}', on device: '${box.diskDevice}'."

              echo -e '\nWARNING: The following procedure will wipe your system clean!'
              echo 'Destruction will ensue.  You have been warned.'
              read -erp 'Do you accept your fate (YES/NO)? ' -i 'NEVER!  HUMANITY WILL PREVAIL!'
              [[ "$REPLY" == YES ]] || exit 1

              echo -e '\nSetting efi boot timeout to zero...'
              efibootmgr --timeout 0 || true

              echo -e '\nDeleting boot order...'
              efibootmgr --delete-bootorder || true

              echo -e '\nPurging efi boot entries...'
              for i in {0..15}; do
                efibootmgr --delete-bootnum --bootnum "$(printf 000%X "$i")" || break
              done

              echo -e '\nDiscarding disk device...'
              blkdiscard --force "${box.diskDevice}" --quiet --verbose

              echo -e '\nPartitioning, formatting and mounting with disko...'
              ${getExe destroyFormatMount} --yes-wipe-all-disks

              echo -e '\nInstalling NixOS...'
              nixos-install --no-root-password --no-channel-copy --flake "${flake}#${box.hostName}"

              echo -e '\nInstalling flake on target system...'
              FLAKE_PATH='/mnt${home}/sandbox/${box.githubUser}/${box.flakeRepoName}'
              git clone https://github.com/${box.githubUser}/${box.flakeRepoName}.git "$FLAKE_PATH"
              GIT_DIR="$FLAKE_PATH"/.git git remote add ${box.githubUser} git@github.com:${box.githubUser}/${box.flakeRepoName}.git
              chown -R 1000:users '/mnt${home}'/sandbox
              ETC_NIXOS_PATH=/mnt/etc/nixos
              mkdir -p "$ETC_NIXOS_PATH"
              ln -s "''${FLAKE_PATH#/mnt}"/flake.nix "$ETC_NIXOS_PATH/"

              echo -e '\nReset password for user ${box.userName}'
              nixos-enter --root /mnt -c 'passwd ${box.userName}'

              echo -e '\nPriming procedure completed successfully.\n'
              echo -e '\nThe cake awaits.'
              read -erp 'Press return to reboot, or Control-D to return to the shell: ' -i 'The cake is a lie!' || exit 1
              echo 'Rebooting...'
              mv -v "$LOGFILE" "$ETC_NIXOS_PATH" # Preserve the log
              reboot
            '';
          }
        )
      );
    };
in
flake.lib.boxen
|> builtins.groupBy (box: box.system)
|> builtins.mapAttrs (
  _system: boxen: boxen |> map (box: nameValuePair box.hostName (mkApp box)) |> listToAttrs
)
