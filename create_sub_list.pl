/*
create_sub_lists(+CharList, -R)
  es cierto si R unifica con una lista con el siguiente formato:
  create_sub_lists([1,2,'W','B',1,2,'W',3,'B',2,4,'W','B'], R)
  R =[ [1,2], ['W'], ['B'], [1,2], ['W'], [3], ['B'], [2,4], ['W'], ['B']]  
*/


create_sub_lists([], []).

create_sub_lists(List, [[Head|List1]|R]):- append([Head|List1], [Elem|List2], List), 
  number(Head), \+ number(Elem),
  create_sub_lists([Elem|List2], R).

create_sub_lists([Head|Tail], [[Head]|R]):- 
  \+ number(Head), 
  create_sub_lists(Tail, R).  