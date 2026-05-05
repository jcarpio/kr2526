
value([Head1, Head2, Head3|_], R):- 
  color_code(Head1, Code1),
  color_code(Head2, Code2),
  color_code(Head3, Code3),
  Code3 =< 1,
  R is (Code1 * 10  + Code2) * 10 ^ Code3.

value([Head1, Head2, Head3|_], R):- 
  color_code(Head1, Code1),
  color_code(Head2, Code2),
  color_code(Head3, Code3),
  Code3 > 1,
  R is (Code1 * 10  + Code2).  

label([Head1, Head2, Head3|_], R2):- value([Head1, Head2, Head3|_], R), 
   number_string(R, StringR), 
   color_code(Head3, Code3),
   sufix_string(Code3, Sufix),
   string_concat(StringR, Sufix, R2).  

sufix_string(0, " ohms").
sufix_string(1, " ohms").
sufix_string(2, " kiloohms").
sufix_string(3, " kiloohms").
sufix_string(4, " kiloohms").
sufix_string(5, " megaohms").
sufix_string(6, " megaohms").
sufix_string(7, " gigaohms").
sufix_string(8, " gigaohms").


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