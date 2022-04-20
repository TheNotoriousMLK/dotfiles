# Brew settings
if [ (uname -s) = "Darwin" ]
  echo 'Setup Brew MacOS'
else
set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew";
set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar";
set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew";
set -q PATH; or set PATH ''; set -gx PATH "/home/linuxbrew/.linuxbrew/bin" "/home/linuxbrew/.linuxbrew/sbin" $PATH;
set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/home/linuxbrew/.linuxbrew/share/man" $MANPATH;
set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/home/linuxbrew/.linuxbrew/share/info" $INFOPATH;
end

# Clear greeting
set -U fish_greeting ""

# Include fish functions
set -l fish_funcs "$HOME/dotfiles/fish/functions"
if not string match -q $fish_funcs $fish_function_path
  set -U fish_function_path $fish_funcs $fish_function_path
end

# Setup Java
# set -gx JAVA_HOME "/home/linuxbrew/.linuxbrew/opt/openjdk";
# set -q PATH; or set PATH ''; set -gx PATH "$JAVA_HOME/bin" $PATH;
# if [ (uname -s) = "Darwin" ]
#   sudo ln -sfn /home/linuxbrew/.linuxbrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
# end

# Setup Powerline Go
function fish_prompt
  powerline-go -error $status -shell bare -hostname-only-if-ssh \
    -modules "venv,docker,host,ssh,cwd,perms,git,jobs,exit" \
    -newline -cwd-max-depth 7
end

function fish_right_prompt
  powerline-go -shell bare -mode "flat" -modules "node"
end

# Python
set -g fish_user_paths "/home/linuxbrew/.linuxbrew/opt/python/libexec/bin" $fish_user_paths

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/home/marlon/google-cloud-sdk/path.fish.inc' ]; . '/home/marlon/google-cloud-sdk/path.fish.inc'; end

# Node 14
#set -g fish_user_paths "/home/linuxbrew/.linuxbrew/opt/node@14/bin" $fish_user_paths

# Dotnet Tools
set -g fish_user_paths "/home/mlk/.dotnet/tools" $fish_user_paths

# NextJS
set -U NEXT_TELEMETRY_DISABLED 1

# Disable dotnet telemetry
set -U DOTNET_CLI_TELEMETRY_OPTOUT 1
