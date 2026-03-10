{ pkgs, ... }:

{
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Shell tools
    eza
    zoxide
    starship
    pay-respects
    carapace
    ripgrep
    fd
    bat
    jq
    fzf
    delta
    # Dev tools
    neovim
    bun
    pnpm
    nodejs
    rustup
    cmake
    nixd
    nixfmt
    alejandra
    typescript-go
  ];

  programs = {
    home-manager = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        bun.format = "\\[[$symbol($version)]($style)\\]";
        c.format = "\\[[$symbol($version(-$name))]($style)\\]";
        cmake.format = "\\[[$symbol($version)]($style)\\]";
        cmd_duration.format = "\\[[⏱ $duration]($style)\\]";
        deno.format = "\\[[$symbol($version)]($style)\\]";
        docker_context.format = "\\[[$symbol$context]($style)\\]";
        dotnet.format = "\\[[$symbol($version)(🎯 $tfm)]($style)\\]";
        elixir.format = "\\[[$symbol($version \\(OTP $otp_version\\))]($style)\\]";
        erlang.format = "\\[[$symbol($version)]($style)\\]";
        fossil_branch.format = "\\[[$symbol$branch]($style)\\]";
        git_branch.format = "\\[[$symbol$branch]($style)\\]";
        git_status.format = "([\\[$all_status$ahead_behind\\]]($style))";
        golang.format = "\\[[$symbol($version)]($style)\\]";
        haskell.format = "\\[[$symbol($version)]($style)\\]";
        java.format = "\\[[$symbol($version)]($style)\\]";
        lua.format = "\\[[$symbol($version)]($style)\\]";
        memory_usage.format = "\\[$symbol[$ram( | $swap)]($style)\\]";
        nim.format = "\\[[$symbol($version)]($style)\\]";
        nix_shell.format = "\\[[$symbol$state( \\($name\\))]($style)\\]";
        nodejs.format = "\\[[$symbol($version)]($style)\\]";
        ocaml.format = "\\[[$symbol($version)(\\($switch_indicator$switch_name\\))]($style)\\]";
        os.format = "\\[[$symbol]($style)\\]";
        package.format = "\\[[$symbol$version]($style)\\]";
        php.format = "\\[[$symbol($version)]($style)\\]";
        python.format = "\\[[\${symbol}\${pyenv_prefix}(\${version})(\\($virtualenv\\))]($style)\\]";
        ruby.format = "\\[[$symbol($version)]($style)\\]";
        rust.format = "\\[[$symbol($version)]($style)\\]";
        sudo.format = "\\[[as $symbol]($style)\\]";
        username.format = "\\[[$user]($style)\\]";
        zig.format = "\\[[$symbol($version)]($style)\\]";
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = false;
    };

    bat.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--height"
        "40%"
        "--border"
        "--reverse"
      ];
    };

    git = {
      enable = true;
      settings = {
        user.name = "yves";
        user.email = "rroughpatch@proton.me";
        init.defaultBranch = "main";
      };
    };

    zsh = {
      enable = true;

      history = {
        share = false;
      };

      shellAliases = {
        ls = "eza $eza_params";
        l = "eza --all --git-ignore $eza_params";
        ll = "eza --all --header --long $eza_params";
        llm = "eza --all --header --long --sort=modified $eza_params";
        lt = "eza --tree $eza_params";
        c = ''open $1 -a "Cursor"'';
      };

      sessionVariables = {
        EDITOR = "nvim";
        PNPM_HOME = "$HOME/Library/pnpm";
        ANDROID_SDK_ROOT = "$HOME/Library/Android/sdk";
        CEF_PATH = "$HOME/.local/share/cef";
        CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
      };

      initContent = ''
        # Ghostty terminfo fix
        if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
          export TERM=xterm-256color
        fi

        # Tool integrations
        eval "$(pay-respects zsh)"
        autoload -U compinit && compinit
        zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
        source <(carapace _carapace)
        if command -v ng &> /dev/null; then source <(ng completion script); fi
        [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

        # Paths
        export PATH="$PNPM_HOME:$HOME/.bun/bin:$HOME/.local/bin:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"
        export DYLD_FALLBACK_LIBRARY_PATH="$DYLD_FALLBACK_LIBRARY_PATH:$CEF_PATH:$CEF_PATH/Chromium Embedded Framework.framework/Libraries"
      '';
    };
  };

  # 1. Install Nix with Determinate Nix:
  #    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  #
  # 2. Clone nix-darwin config to ~/.config/nix-darwin
  #
  # 3. Run home-manager switch:
  #    nix flake update ~/.config/nix-darwin
  #    nix run nix-darwin -- switch --flake ~/.config/nix-darwin
  #
}
