function peco_select_history
  if test (count $argv) = 0
    set peco_flags --layout=bottom-up
  else
    set peco_flags --layout=bottom-up --query "$argv"
  end

  history | peco --prompt="history>" $peco_flags | read result

  if [ $result ]
    commandline $result
  else
    commandline ''
  end
end
