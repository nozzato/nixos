{ config, lib, pkgs, ... }: {
  home.activation.makeDirectories = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $VERBOSE_ARG \
        ${config.home.homeDirectory}/app \
        ${config.home.homeDirectory}/audio \
        ${config.home.homeDirectory}/audio/music \
        ${config.home.homeDirectory}/doc \
        ${config.home.homeDirectory}/download \
        ${config.home.homeDirectory}/game \
        ${config.home.homeDirectory}/tmp \
        ${config.home.homeDirectory}/visual \
        ${config.home.homeDirectory}/visual/capture \
        ${config.home.homeDirectory}/visual/screenshots/desktop \
        ${config.home.homeDirectory}/visual/screenshots/steam
  '';
}