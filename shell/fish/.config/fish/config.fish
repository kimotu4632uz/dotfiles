if status is-interactive
  source ~/.myenv/env
  starship init fish | source

  if [ $SHLVL = 1 ]
    fcitx-autostart &> /dev/null &
    xset -r 49  > /dev/null 2>&1
  end 
end
