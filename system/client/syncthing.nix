{ ... }: {
  services.syncthing = {
    enable = true;
    user = "noah";
    dataDir = "/home/noah/Sync";
    configDir = "/home/noah/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      options = {
        urAccepted = -1;
      };
      devices = {
        "nozbox" = { id = "BVC35LK-YROXVMS-SMWLNUS-DYKEFWM-ADO4TKJ-5JYHHIR-LLOAW72-BOLYZAR"; };
      };
      folders = {
        "nozbox-noah" = {
          path = "~/Sync/nozbox";
          devices = [ "nozbox" ];
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "2592000";
            };
          };
        };
      };
    };
  };
}
