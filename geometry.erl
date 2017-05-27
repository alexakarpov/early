-module(geometry).
-export([area/1]).

area({rectangle, Width, Height}) ->
    Width * Height;
area({square, Size}) -> Size * Size;
area({rtriangle, Base, Height}) -> Base * Height / 2.


