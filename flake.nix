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
      pkgs,
      ...
    }: let
      # Writable app configs are linked here instead of the read-only store,
      # so the applications can save their changes into the repository.
      live = "${config.home.homeDirectory}/.dotfiles";

      # Read-only dotfiles shipped in the flake source (Nix store).
      readOnly = {
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
        "starship.toml" = {
          source = "${self}/.config/starship.toml";
        };
        "code-flags.conf" = {
          source = "${self}/.config/code-flags.conf";
        };
      };

      # Writable app config linked to the local checkout.
      writable = {
        "caelestia".source =
          config.lib.file.mkOutOfStoreSymlink "${live}/.config/caelestia";

        "obs-studio/basic/profiles/phone-vertical".source =
          config.lib.file.mkOutOfStoreSymlink "${live}/.config/obs-studio/basic/profiles/phone-vertical";
        "obs-studio/basic/scenes".source =
          config.lib.file.mkOutOfStoreSymlink "${live}/.config/obs-studio/basic/scenes";
      };
    in {
      options.dotfiles.enable = lib.mkEnableOption "PhiNix dotfiles";

      config = lib.mkIf config.dotfiles.enable {
        xdg.configFile = readOnly // writable;

        home.file = {
          "README.md" = {
            source = "${self}/README.md";
          };
          "Pictures/Wallpapers/blizz.jpg" = {
            source = "${self}/Pictures/Wallpapers/blizz.jpg";
          };
          "Pictures/Wallpapers/noir.jpg" = {
            source = "${self}/Pictures/Wallpapers/noir.jpg";
          };
          "Pictures/Screenshots/blizz.png" = {
            source = "${self}/Pictures/Screenshots/blizz.png";
          };
          "Pictures/Screenshots/noir.png" = {
            source = "${self}/Pictures/Screenshots/noir.png";
          };
        };

        # Clone the local checkout on first activation if it is missing. The
        # links above become valid once the clone finishes; a failure only
        # warns and is retried on the next switch.
        home.activation.cloneDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
          repo="${live}"

          if [ ! -d "$repo/.git" ]; then
            if [ -e "$repo" ]; then
              warnEcho "dotfiles: $repo exists but is not a git checkout; leaving it alone."
            else
              partial="$repo.clone-partial"
              ${pkgs.coreutils}/bin/rm -rf "$partial"

              if [ -z "''${DRY_RUN_CMD:-}" ]; then
                if ${pkgs.git}/bin/git clone \
                     https://github.com/lPhiNix/dotfiles.git "$partial"; then
                  ${pkgs.coreutils}/bin/mv "$partial" "$repo"
                else
                  ${pkgs.coreutils}/bin/rm -rf "$partial"
                  warnEcho "dotfiles: clone failed; retrying on next switch."
                fi
              else
                echo "Would clone https://github.com/lPhiNix/dotfiles.git to $repo"
              fi
            fi
          fi
        '';
      };
    };
  };
}
