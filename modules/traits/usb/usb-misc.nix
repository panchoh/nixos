{
  pkgs,
  ...
}: {
  services.udev.packages = [
    (pkgs.writeTextFile rec {
      name = "98-usb-misc.rules";
      destination = "/etc/udev/rules.d/${name}";
      text = ''
        # Sandisk Extreme Pro
        ACTION=="add|change",                \
          ATTRS{idVendor}=="0781",           \
          ATTRS{idProduct}=="55a8",          \
          SUBSYSTEM=="scsi_disk",            \
          ATTR{provisioning_mode}="unmap"

        # UGreen NVMe Caddy
        ACTION=="add|change",                \
          ATTRS{idVendor}=="0bda",           \
          ATTRS{idProduct}=="9210",          \
          SUBSYSTEM=="scsi_disk",            \
          ATTR{provisioning_mode}="unmap"

        # Apple's USB SuperDrive
        # https://kuziel.nz/notes/2018/02/apple-superdrive-linux.html
        ACTION=="add",                       \
          ATTRS{idProduct}=="1500",          \
          ATTRS{idVendor}=="05ac",           \
          DRIVERS=="usb",                    \
          RUN+="${pkgs.sg3_utils}/bin/sg_raw /dev/'$kernel' EA 00 00 00 00 00 01"

        # Prevent Logitech BRIO Webcam microphone from being activated.
        ACTION=="add",                       \
          SUBSYSTEMS=="usb",                 \
          ATTRS{idVendor}=="046d",           \
          ATTRS{idProduct}=="085e",          \
          ATTR{bInterfaceClass}=="01",       \
          ATTR{authorized}="0"

        # Logitech C505e HD Webcam
        SUBSYSTEM=="video4linux",            \
          KERNEL=="video[0-9]*",             \
          ATTRS{product}=="C505e HD Webcam", \
          ATTR{index}=="0",                  \
          RUN+="${pkgs.v4l-utils}/bin/v4l2-ctl -d '$devnode' --set-ctrl=power_line_frequency=1"

        # Shokz OpenComm2 UC
        SUBSYSTEM=="usb",                    \
          ATTRS{idVendor}=="3511",           \
          ATTRS{idProduct}=="2b1e",          \
          DRIVER=="usbhid",                  \
          ATTR{authorized}="0"
      '';
    })
  ];
}
