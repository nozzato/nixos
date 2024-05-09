{
  lib,
  ...
}: {
  systemd.nspawn.active-archlinux = {
    filesConfig = {
      Bind = [
        "/dev/dri"
        "/dev/kfd"
      ];
      TemporaryFileSystem = "/tmp:size=100%";
    };
    execConfig = {
      PrivateUsers = false;
    };
    networkConfig = {
      Private = false;
    };
  };
  system.activationScripts.linkActiveArchlinux = lib.stringAfter [ "var" ] ''
    ln -fs /media/active-linux/machines/active-archlinux /var/lib/machines/active-archlinux
  '';
}
