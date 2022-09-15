if status is-interactive
  if not type -q fisher
    curl -sL https://git.io/fisher | source
    fisher update
  end

  starship init fish | source
end
