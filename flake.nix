{
  description = "PhiNix dotfiles";

  outputs = {self}: {
    # Home Manager module that deploys every dotfile into the home directory.
    # Import it and enable it:
    #
    #   imports = [inputs.dotfiles.homeManagerModules.default];
    #   dotfiles.enable = true;
    homeManagerModules.default = {
      config,
      lib,
      ...
    }: {
      options.dotfiles.enable = lib.mkEnableOption "PhiNix dotfiles";

      config = lib.mkIf config.dotfiles.enable {
        xdg.configFile = {
          "fish" = {
            source = "${self}/.config/fish";
            recursive = true;
          };
          "btop" = {
            source = "${self}/.config/btop";
            recursive = true;
          };
          "fastfetch" = {
            source = "${self}/.config/fastfetch";
            recursive = true;
          };
          "Code" = {
            source = "${self}/.config/Code";
            recursive = true;
          };
          "nvim" = {
            source = "${self}/.config/nvim";
            recursive = true;
          };
          "hypr" = {
            source = "${self}/.config/hypr";
            recursive = true;
          };
          "kitty" = {
            source = "${self}/.config/kitty";
            recursive = true;
          };
          "caelestia" = {
            source = "${self}/.config/caelestia";
            recursive = true;
          };
          "starship.toml" = {
            source = "${self}/.config/starship.toml";
          };
          "code-flags.conf" = {
            source = "${self}/.config/code-flags.conf";
          };
        };

        home.file = {
          "README.md" = {
            source = "${self}/README.md";
          };
          "install.sh" = {
            source = "${self}/install.sh";
          };
          "Pictures/Wallpapers/noir.jpg" = {
            source = "${self}/Pictures/Wallpapers/noir.jpg";
          };
          "Pictures/Screenshots/noir.png" = {
            source = "${self}/Pictures/Screenshots/noir.png";
          };
        };
      };
    };
  };
}
