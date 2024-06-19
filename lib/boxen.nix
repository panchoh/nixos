inputs: let
  defaults = {
    stateVersion = "24.05";
    system = "x86_64-linux";
    hostName = "nixos";
    macvlanAddr = "de:ad:be:ef:00:00";
    timeZone = "Europe/Madrid";
    isLaptop = false;
    diskDevice = "/dev/nvme0n1";
    hasMedia = true;
    userName = "pancho";
    userDesc = "pancho horrillo";
    userEmail = "pancho@pancho.name";
    githubUser = "panchoh";
    gpgSigningKey = "4430F5028B19FAF4A40EC4E811E0447D4ABBA7D0";
    virtualHost = "canalplus.pancho.name";
    virtualHostRoot = "FF2E6E41-1FE8-4515-82D1-56D5C49EB2B5";
    userKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhtv6KrJc04bydU2mj6j/V6g/g+RiY1+gTg9h4z3STm pancho"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOK1QiBQzjzVDZoyWwewN8U0B6QRn09dasbcyTI48dWL pancho@ipad"
    ];
    extraModules = [];
    extraHMModules = [];
  };

  makeBox = overrides: defaults // overrides;
in [
  (makeBox {
    hostName = "helium";
    macvlanAddr = "1c:69:7a:02:8d:23";
    extraModules = [inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh];
  })
  (makeBox {
    hostName = "krypton";
    macvlanAddr = "1c:69:7a:06:76:c0";
    extraModules = [inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh];
  })
  (makeBox {
    hostName = "xenon";
    macvlanAddr = "48:21:0b:3c:16:a9";
    hasMedia = false;
    extraModules = [({config, ...}: {config.traits.caddy.enable = true;})];
  })
  (makeBox {
    hostName = "magnesium";
    macvlanAddr = "00:2b:67:11:27:06";
    isLaptop = true;
    hasMedia = false;
    extraModules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490
      ({config, ...}: {config.traits.epb.enable = true;})
    ];
  })
  (makeBox {
    hostName = "nixos";
    diskDevice = "/dev/vda";
    hasMedia = false;
  })
  # FIXME: this flake is still x86_64 centric, so it can't yet configure my Raspberry Pi 4
  # (makeBox {
  #   system = "aarch64-linux";
  #   hostName = "neon";
  #   macvlanAddr = "dc:a6:32:b1:ae:1d";
  #   hasMedia = false;
  #   extraModules = [inputs.nixos-hardware.nixosModules.raspberry-pi-4];
  # })
]
