if status is-interactive
  source ~/.myenv/env
  starship init fish | source

#  export (dbus-launch)
  export GTK_IM_MODULE=fcitx
  export QT_IM_MODULE=fcitx
  export XMODIFIERS=@im=fcitx
  export DefaultIMModule=fcitx
  if [ $SHLVL = 1 ]
    fcitx-autostart &> /dev/null &
    xset -r 49  > /dev/null 2>&1
  end 
end
