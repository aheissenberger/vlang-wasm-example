struct winsize { unsigned short int ws_row, ws_col, ws_xpixel, ws_ypixel; };

#ifndef TIOCGWINSZ
#define TIOCGWINSZ 0
#endif