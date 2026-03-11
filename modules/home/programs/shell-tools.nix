{ ... }:
{
  programs = {
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
  };
}
