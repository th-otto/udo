export PKG_CONFIG_LIBDIR=/usr/m68k-atari-mint/lib/pkconfig
export PKG_CONFIG_PATH="${PKG_CONFIG_LIBDIR}"
./configure --host=m68k-atari-mint --target=m68k-atari-mint --enable-warnings --enable-fatal-warnings 'CFLAGS=-O2 -I/home/sebilla/atari/mintlib/include'
