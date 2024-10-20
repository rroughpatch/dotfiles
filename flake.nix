{
  description = "meow";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, nix-homebrew, ... }:
    let
      configuration = { pkgs, config, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = with pkgs; [
          neovim
          tmux
          raycast
          alacritty
          mkalias
          fish
        ];

        fonts.packages = [
          (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];

        homebrew = {
          enable = true;
          brews = [
            "mas"
          ];
          casks = [
            "cursor"
            "iina"
          ];
          masApps = {
            # Add Mac App Store apps here
          };
        };

        system.activationScripts.applications.text = let
          env = pkgs.buildEnv {
            name = "system-applications";
            paths = config.environment.systemPackages;
            pathsToLink = "/Applications";
          };
        in
          pkgs.lib.mkForce ''
            # Set up applications.
            echo "setting up /Applications..." >&2
            rm -rf /Applications/Nix\ Apps
            mkdir -p /Applications/Nix\ Apps
            find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            while read src; do
              app_name=$(basename "$src")
              echo "copying $src" >&2
              ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            done
          '';

        system.activationScripts.postActivation.text = ''
          # Existing activation scripts
          ${config.system.activationScripts.applications.text}

          # Wootility installation
          if [ ! -d "/Applications/Wootility.app" ]; then
            echo "Downloading and installing Wootility..."
            curl -L "https://api.wooting.io/public/wootility/download?os=mac&branch=lekker&platform=arm64" -o /tmp/Wootility.dmg
            hdiutil attach /tmp/Wootility.dmg
            VOLUME_INFO=$(hdiutil info | grep -E '/Volumes/.*wootility')
            VOLUME_PATH=$(echo "$VOLUME_INFO" | awk -F $'\t' '{print $3}')
            if [ -n "$VOLUME_PATH" ]; then
              echo "Mounted volume: $VOLUME_PATH"
              APP_PATH=$(find "$VOLUME_PATH" -maxdepth 1 -name "*.app" -print -quit)
              if [ -n "$APP_PATH" ]; then
                echo "Found app: $APP_PATH"
                cp -R "$APP_PATH" /Applications/
                echo "Wootility installed successfully."
              else
                echo "Error: Could not find Wootility app in the mounted volume."
                ls -R "$VOLUME_PATH"
              fi
              hdiutil detach "$VOLUME_PATH"
            else
              echo "Error: Could not find mounted Wootility volume."
              hdiutil info
            fi
            rm /tmp/Wootility.dmg
          fi
        '';

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        # LEAVE ZSH JUST IN CASE SOMETHING BREAKS!!
        programs.zsh.enable = true;  # default shell on catalina
        programs.fish.enable = true;
        users.users.soak.shell = pkgs.fish;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        environment.shells = with pkgs; [ fish ];
      };
    in
    {
      darwinConfigurations."ghost" = nix-darwin.lib.darwinSystem {
        modules = [ 
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "soak";
              autoMigrate = true;
            };
          }
        ];
      };

      darwinPackages = self.darwinConfigurations."ghost".pkgs;
    };
}
