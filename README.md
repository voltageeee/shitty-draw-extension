# shitty-draw-extension
shitty extension of a draw library

functions:
draw.HalfCircle(args: position by x, position by y, radius, color, which half is removed (1 == bottom, 2 == left, 3 == top, 4 == right), thickness of a circle) - draws a half of a circle
draw.SimpleGradient(args: position by x, position by y, width, height, first color, second color, is it horizontal (true/false) - draws a simple linear gradient
draw.SimpleRadialGradient(args: position by x, position by y, radius, first color, second color) - draws a simple radial gradient

i will update it as i will try and continue to work with meshes and stencils.
as for now, i won't really recommend to use it as it may be shitty and unoptimized.
pasted linear gradients from here:
https://github.com/Bo98/garrysmod-util/blob/master/lua/autorun/client/gradient.lua
