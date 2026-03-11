{ ... }:
{
  programs.starship = {
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
}
