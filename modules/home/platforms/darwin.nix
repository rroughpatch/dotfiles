{ lib, ... }:
{
  programs.zsh = {
    shellAliases.c = ''open $1 -a "Cursor"'';

    sessionVariables = {
      PNPM_HOME = "$HOME/Library/pnpm";
      ANDROID_SDK_ROOT = "$HOME/Library/Android/sdk";
      CEF_PATH = "$HOME/.local/share/cef";
    };

    initContent = lib.mkAfter ''
      # Paths
      export PATH="$PNPM_HOME:$HOME/.bun/bin:$HOME/.local/bin:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"
      export DYLD_FALLBACK_LIBRARY_PATH="$DYLD_FALLBACK_LIBRARY_PATH:$CEF_PATH:$CEF_PATH/Chromium Embedded Framework.framework/Libraries"
    '';
  };
}
