{ config, lib, pkgs, ... }: {
  programs.vim = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-numbertoggle
    ];
    extraLuaConfig = ''
      vim.opt.clipboard = "unnamedplus"
      vim.opt.expandtab = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.shortmess:append("I")
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.cursorline = true
      vim.opt.whichwrap:append "<,>,[,],h,l"
    '';
  };
}
