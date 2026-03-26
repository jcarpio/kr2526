
/*
permutation(+List, -ListR)
  is true if ListR unify with any permutation of List.  
*/

permutation([], []).
permutation([Head|Tail], R2):- permutation(Tail, R), insert_all(Head, R, R2).


/*

insert_all(+Elem, +List, -ListR)
  is true if ListR unify with Elem inserted in any
  possible position of List.

*/

insert_all(Elem, List, [Elem|List]).

insert_all(Elem, [Head|Tail], [Head|R]):- insert_all(Elem, Tail, R).