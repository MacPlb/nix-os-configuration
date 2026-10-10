{ ... }:

{
  programs.bash.enable = true;

  # Program to style bash look
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      git_branch = {
        style = "purple";
        format = "[$symbol$branch]($style) ";
      };
      git_status = {
        style = "purple";
        format = "([$all_status$ahead_behind]($style) )";
      };
    };
  };
}
