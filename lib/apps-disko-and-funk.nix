inputs:
let
  inherit (inputs.nixpkgs.lib.meta) getExe;
  inherit (inputs.nixpkgs.lib.attrsets) listToAttrs nameValuePair;
  inherit (builtins) groupBy mapAttrs;

  mkApp =
    box:
    let
      inherit (inputs.nixpkgs.legacyPackages.${box.system}) pkgs;
      inherit (inputs.self.nixosConfigurations.${box.hostName}.config.system.build) destroyFormatMount;
      inherit (inputs.self.nixosConfigurations.${box.hostName}.config.users.users.${box.userName}) home;
      inherit (box)
        hostName
        diskDevice
        userName
        userDesc
        userEmail
        githubUser
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
              coreutils # for chown, ln, mkdir and printf
              util-linux # for blkdiscard
              git
            ];
            # bashOptions = ["errexit" "nounset" "pipefail" "xtrace"];
            text = ''
              echo -e '\nWelcome to Cyberdyne Systems T-series maintenance flake.'
              echo -e '\nGreetings, human with ID: "${userDesc} (${userName}) <${userEmail}>", GitHub account: "${githubUser}".'
              echo -e "\nYou have requested the priming of the box designated as '${hostName}', on device: '${diskDevice}'."

              [[ $EUID -eq 0 ]] || { echo 'Skynet needs total control.  Run me again with run0.  Aborting...' 1>&2; exit 1; }

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
              ${getExe destroyFormatMount} --yes-wipe-all-disks &>> log

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

              echo -e '\nReset password for user ${userName}'
              nixos-enter --root /mnt -c 'passwd ${userName}'

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
inputs.self.lib.boxen
|> groupBy (box: box.system)
|> mapAttrs (
  _system: boxen: boxen |> map (box: nameValuePair box.hostName (mkApp box)) |> listToAttrs
)
