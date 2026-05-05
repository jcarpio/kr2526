value([], 0).
value([Head|Tail], R):- length([Head|Tail], L), L  = 2,
  L2 is L - 1, 
  value(Tail, Value), 
  color_code(Head, Code),
  R is Value + Code * 10.
  
color_code("black", 0).
color_code("brown", 1).
color_code("red", 2).
color_code("orange", 3).
color_code("yellow", 4).
color_code("green", 5).
color_code("blue", 6).
color_code("violet", 7).
color_code("grey", 8).
color_code("white", 9).

colors(Colors):- 
  Colors = [
            "black",
            "brown",
            "red",
            "orange",
            "yellow",
            "green",
            "blue",
            "violet",
            "grey",
            "white"
        ].