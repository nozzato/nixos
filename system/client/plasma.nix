{
  lib,
  ...
}: {
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
  };
  system.activationScripts.makeSddmKcminputrc = lib.stringAfter [ "var" ] ''
    cat << EOF > /var/lib/sddm/.config/kcminputrc
    [Keyboard]
    NumLock=0

    [Libinput][1241][41119][E-Signal USB Gaming Mouse]
    PointerAcceleration=0.2
    PointerAccelerationProfile=1

    [Mouse]
    X11LibInputXAccelProfileFlat=true
    EOF
  '';

  services.desktopManager.plasma6.enable = true;
}
