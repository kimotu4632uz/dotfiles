# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import *

# [Global modemap] Change modifier keys as in xmodmap
define_modmap({
    Key.CAPSLOCK: Key.LEFT_CTRL
})

# SandS
define_multipurpose_modmap({
    Key.SPACE: [Key.SPACE, Key.LEFT_SHIFT],
})

# Send muhenkan when enter Esc
define_keymap(re.compile('Alacritty'), {
    K('esc'): [K('muhenkan'), K('esc')]
}, "Esc and IME off")

