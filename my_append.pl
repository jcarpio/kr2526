/*

my_append(?List1, ?List2, ?R) 
  is true if R is the concatenation of List1 and List2.
  
*/

my_append([], L2, L2).
my_append([Head|Tail], L2, [Head|R]):- my_append(Tail, L2, R).
