{ config, pkgs, ... }:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;
in {
  home.username = "logans";
  home.homeDirectory = "/home/logans";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    difftastic
    glow  # markdown previewer in terminal
  ];

  programs.git.enable = true;
  programs.alacritty.enable = true;
  programs.waybar.enable = true;

  xdg.configFile."nvim" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";
    recursive = true;
  };

  xdg.configFile."sway" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/sway";
    recursive = true;
  };
  xdg.configFile."swaylock" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/swaylock";
    recursive = true;
  };
  xdg.configFile."mako" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/mako";
    recursive = true;
  };
  xdg.configFile."rofi" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/rofi";
    recursive = true;
  };
  xdg.configFile."waybar" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/waybar";
    recursive = true;
  };
  xdg.configFile."wob" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/wob";
    recursive = true;
  };
  xdg.configFile."wpaperd" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/wpaperd";
    recursive = true;
  };

  home.file.".tmux.conf".source = symlink "${config.home.homeDirectory}/.dotfiles/tmux/.tmux.conf";

  home.file.".zshrc".source = symlink "${config.home.homeDirectory}/.dotfiles/zsh/.zshrc";
  home.file.".aliases".source = symlink "${config.home.homeDirectory}/.dotfiles/zsh/.aliases";
  home.file.".antigenrc".source = symlink "${config.home.homeDirectory}/.dotfiles/zsh/.antigenrc";
  # home.file.".profile".source = symlink "${config.home.homeDirectory}/.dotfiles/zsh/.profile";
  home.file.".zshenv".source = symlink "${config.home.homeDirectory}/.dotfiles/zsh/.zshenv";

  home.file.".gitconfig".source = symlink "${config.home.homeDirectory}/.dotfiles/git/.gitconfig";
  home.file.".git-template" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/git/.git-template";
    recursive = true;
  };

  xdg.configFile."alacritty" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/alacritty/.config/alacritty";
    recursive = true;
  };

  services.udiskie = {
    enable = true;
    settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        # program_options = {
        #     # replace with your favorite file manager
        #     file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
        # };
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
