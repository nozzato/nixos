{ config, lib, pkgs, ... }: {
  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-numbertoggle
    ];
    extraConfig = ''
      set clipboard="unnamedplus"
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set shortmess="filnxtToOSI"
      set ignorecase
      set smartcase
      set number
      set relativenumber
      set cursorline
      set whichwrap="b,s,<,>,[,],h,l"
    '';
  };
}
