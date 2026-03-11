{ ... }:
{
  programs.zsh = {
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
}
