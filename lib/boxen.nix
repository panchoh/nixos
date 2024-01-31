{nixos-hardware}: let
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
  }: {
    inherit hostName hostType macvlanAddr system stateVersion timeZone isLaptop userName userDesc userEmail;
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
  })
  (makeBox {
    hostName = "magnesium";
    macvlanAddr = "00:2b:67:11:27:06";
    hostType = nixos-hardware.nixosModules.lenovo-thinkpad-t490;
    isLaptop = true;
  })
  (makeBox {
    hostName = "neon";
    macvlanAddr = "dc:a6:32:b1:ae:1d";
    system = "aarch64-linux";
    hostType = nixos-hardware.nixosModules.raspberry-pi-4;
  })
]
