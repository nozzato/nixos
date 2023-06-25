{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    mpc-cli
    playerctl
    ymuse
  ];

  services.playerctld.enable = true;

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/audio/music";
    extraConfig = ''
      auto_update "yes"
      restore_paused "yes"

      audio_output {
        type "pipewire"
        name "PipeWire"
      }
    '';
  };
  services.mpd-mpris.enable = true;

  programs.ncmpcpp = {
    enable = true;
    settings = {
      autocenter_mode = true;
    };
  };

  home.file."${config.xdg.configHome}/ymuse/config.json".text = ''
    {
      "MpdNetwork": "tcp",
      "MpdSocketPath": "/run/user/1000/mpd/socket",
      "MpdHost": "",
      "MpdPort": 6600,
      "MpdPassword": "",
      "MpdAutoConnect": true,
      "MpdAutoReconnect": true,
      "QueueColumns": [
        {
          "ID": 0,
          "Width": 344
        },
        {
          "ID": 13,
          "Width": 80
        },
        {
          "ID": 6,
          "Width": 41
        },
        {
          "ID": 8,
          "Width": 41
        },
        {
          "ID": 7,
          "Width": 837
        },
        {
          "ID": 2,
          "Width": 331
        },
        {
          "ID": 22,
          "Width": 143
        },
        {
          "ID": 9,
          "Width": 0
        }
      ],
      "QueueToolbar": true,
      "DefaultSortAttrID": 10,
      "TrackDefaultReplace": false,
      "PlaylistDefaultReplace": true,
      "StreamDefaultReplace": true,
      "PlayerSeekDuration": 2,
      "PlayerTitleTemplate": "{{- if or .Title .Album | or .Artist -}}\n\u003cbig\u003e\u003cb\u003e{{ .Title | default \"(unknown title)\" }}\u003c/b\u003e\u003c/big\u003e\nby \u003cb\u003e{{ .Artist | default \"(unknown artist)\" }}\u003c/b\u003e from \u003cb\u003e{{ .Album | default \"(unknown album)\" }}\u003c/b\u003e\n{{- else if .Name -}}\n\u003cbig\u003e\u003cb\u003e{{ .Name }}\u003c/b\u003e\u003c/big\u003e\n{{- else if .file -}}\nFile \u003cbig\u003e\u003cb\u003e{{ .file | basename }}\u003c/b\u003e\u003c/big\u003e\nfrom \u003cb\u003e{{ .file | dirname }}\u003c/b\u003e\n{{- else -}}\n\u003ci\u003e(no track)\u003c/i\u003e\n{{- end -}}\n",
      "PlayerAlbumArtTracks": true,
      "PlayerAlbumArtStreams": true,
      "PlayerAlbumArtSize": 80,
      "SwitchToOnQueueReplace": false,
      "PlayOnQueueReplace": false,
      "MaxSearchResults": 500,
      "Streams": [],
      "LibraryPath": "playlists\u0001"
    }
  '';
}
