
:- use_module(library(clpfd)).

combination(Digits, Sum, List2, R):-
  length(List, Digits),
  List ins 1..9,
  all_distinct(List),
  sum_clpfd(List, Sum),
  label(List),
  list_to_fdset(List, Set),
  list_to_fdset(List2, Set2),
  fdset_disjoint(Set, Set2),
  sort(List, R).
  
combinations(Digits, Sum, List2, R):-
 setof(List, combination(Digits,Sum,List2,List), R).  
  
sum_clpfd([], 0).
sum_clpfd([Head|Tail], R2):-
   sum_clpfd(Tail, R),
   R2 #= R + Head.
   
