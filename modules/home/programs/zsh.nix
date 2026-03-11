{ ... }:
{
  programs.zsh = {
    enable = true;

    history = {
      share = false;
    };

    shellAliases = {
      ls = "eza --icons=auto $eza_params";
      l = "eza --all --git-ignore --icons=auto $eza_params";
      la = "eza --all --long --icons=auto $eza_params";
      ll = "eza --all --header --long --icons=auto $eza_params";
      llm = "eza --all --header --long --sort=modified --icons=auto $eza_params";
      lt = "eza --tree --icons=auto $eza_params";
      cat = "bat";
    };

    sessionVariables = {
      EDITOR = "nvim";
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
    '';
  };
}
