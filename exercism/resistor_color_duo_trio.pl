
num_zeros("black", B, N):-
  color_code(B, Code), N is Code + 1.
 
num_zeros(A, B, N):-
  A \= "black",
  color_code(B, N).


value([Head1, Head2, Head3|_], R):- 
  color_code(Head1, Code1),
  color_code(Head2, Code2),
  color_code(Head3, Code3),
  R is (Code1 * 10  + Code2) * 10 ^ Code3.


label([Head1, Head2, Head3|_], R2):- 
   value([Head1, Head2, Head3|_], R), 
   R < 1000,
   number_string(R, StringR), 
   string_concat(StringR, " ohms", R2).  


label([Head1, Head2, Head3|_], R3):- 
   value([Head1, Head2, Head3|_], R), 
   R >= 1000, R < 1000000,
   R2 is R / 1000,
   number_string(R2, StringR), 
   string_concat(StringR, " kiloohms", R3).  
   
label([Head1, Head2, Head3|_], R3):- 
   value([Head1, Head2, Head3|_], R), 
   R >= 1000000, R < 1000000000,
   R2 is R / 1000000,
   number_string(R2, StringR), 
   string_concat(StringR, " megaohms", R3).     

label([Head1, Head2, Head3|_], R3):- 
   value([Head1, Head2, Head3|_], R), 
   R >= 1000000000, R < 1000000000000,
   R2 is R / 1000000000,
   number_string(R2, StringR), 
   string_concat(StringR, " gigaohms", R3).


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
