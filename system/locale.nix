{ ... }: {
  console.keyMap = "uk";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_NUMERIC = "C.UTF-8";
      LC_NAME = "C.UTF-8";
    };
  };

  time.timeZone = "Europe/London";
}
