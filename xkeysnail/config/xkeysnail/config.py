# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import *

# [Global modemap] Change modifier keys as in xmodmap
#define_modmap({
#    Key.CAPSLOCK: Key.LEFT_CTRL
#})

# [Multipurpose modmap] Give a key two meanings. A normal key when pressed and
# released, and a modifier key when held down with another key. See Xcape,
# Carabiner and caps2esc for ideas and concept.
define_multipurpose_modmap({
    # SandS
    Key.SPACE: [Key.SPACE, Key.LEFT_SHIFT],
    # ALT as Henkan, Muhenkan
    Key.LEFT_ALT: [Key.MUHENKAN, Key.LEFT_ALT],
    Key.RIGHT_ALT: [Key.HENKAN, Key.RIGHT_ALT]
})

# Send muhenkan when enter Esc
define_keymap(re.compile('Alacritty'), {
    K('esc'): [K('muhenkan'), K('esc')]
}, "Esc and IME off")

define_keymap(re.compile('obsidian'), {
    K('esc'): [K('muhenkan'), K('esc')]
}, "Esc and IME off")

