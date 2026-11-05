// Quarto template partial (replaces Quarto's default article template).
// Loads the layout functions and the theme chosen by `program-theme`.
#import "theme/layout.typ": *
#import "theme/theme-$if(program-theme)$$program-theme$$else$apsrc$endif$.typ": theme
