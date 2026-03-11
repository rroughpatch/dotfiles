{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "yves";
      user.email = "rroughpatch@proton.me";
      init.defaultBranch = "main";
    };
  };
}
