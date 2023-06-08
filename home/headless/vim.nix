{ config, lib, pkgs, ... }: {
  programs.vim = {
    enable = true;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = ''
      vim.opt.clipboard = "unnamedplus"
      vim.opt.expandtab = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.shortmess:append("I")
    '';
  };
}
