if status is-interactive
  if not type -q fisher
    curl -sL https://git.io/fisher | source
    fisher update
  end

  if test (uname -s) = "Darwin"
    eval (/opt/homebrew/bin/brew shellenv)
  end

  starship init fish | source

  if test (uname -s) = "Darwin"
    source /opt/homebrew/opt/asdf/libexec/asdf.fish
  end
end
