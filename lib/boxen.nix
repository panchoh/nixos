nixos-hardware: let
  makeBox = {
    hostName ? "nixos",
    hostType ? null,
    macvlanAddr,
    system ? "x86_64-linux",
    stateVersion ? "23.11",
    timeZone ? "Europe/Madrid",
    isLaptop ? false,
    userName ? "pancho",
    userDesc ? "pancho horrillo",
    userEmail ? "pancho@pancho.name",
    userVirtualHost ? "canalplus.pancho.name",
    userVirtualHostRoot ? "FF2E6E41-1FE8-4515-82D1-56D5C49EB2B5",
    userKeys ? [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhtv6KrJc04bydU2mj6j/V6g/g+RiY1+gTg9h4z3STm pancho"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOK1QiBQzjzVDZoyWwewN8U0B6QRn09dasbcyTI48dWL pancho@ipad"
    ],
    extraModule ? {},
  }: {
    inherit hostName hostType macvlanAddr system stateVersion timeZone isLaptop userName userDesc userEmail userVirtualHost userVirtualHostRoot userKeys extraModule;
  };
in [
  (makeBox {
    hostName = "helium";
    macvlanAddr = "1c:69:7a:02:8d:23";
    hostType = nixos-hardware.nixosModules.intel-nuc-8i7beh;
  })
  (makeBox {
    hostName = "krypton";
    macvlanAddr = "1c:69:7a:06:76:c0";
    hostType = nixos-hardware.nixosModules.intel-nuc-8i7beh;
    extraModule = {config, ...}: {config.traits.caddy.enable = true;};
  })
  (makeBox {
    hostName = "magnesium";
    macvlanAddr = "00:2b:67:11:27:06";
    hostType = nixos-hardware.nixosModules.lenovo-thinkpad-t490;
    isLaptop = true;
  })
  # FIXME: this flake is still x86_64 centric, so it can't yet configure my Raspberry Pi 4
  # (makeBox {
  #   hostName = "neon";
  #   macvlanAddr = "dc:a6:32:b1:ae:1d";
  #   system = "aarch64-linux";
  #   hostType = nixos-hardware.nixosModules.raspberry-pi-4;
  # })
]
