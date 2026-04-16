
my_zip([], []).

my_zip([Elem], [(Elem,1)]).

my_zip([Head, Head|Tail], [(Elem,N2)|R]  ):-  
  my_zip([Head|Tail], [(Elem,N)|R]), N2 is N + 1.

my_zip([Head1, Head2|Tail],  [(Head1,1)|R]):- 
  Head1 \= Head2, my_zip([Head2|Tail], R).
  
  
/*  
encode(+String, -StringResult)
*/

encode(String, R5):- string_chars(String, List), my_zip(List, R), translate(R, R2),
  delete_one(R2,R3),
  translate_list_atoms_chars(R3, R4), string_chars(R5, R4).

/*

translate(+List, ListResult)
  is true if ListResult unify with a list in this format:
  translate([(a, 2), (b, 2), (c, 1), (d, 2), (e, 2), (f, 4)] , R).
  R= [2,a,2,b,1,c,2,d,2,e,4,f]
  
*/


translate([], []).

translate([(Elem, Number)|Tail], [Number,Elem|R]):-
  translate(Tail, R).
  
  
/*
delete_one(+List, -R)
  is true if R unify with a list with same elements than
  List removing the number 1
*/

delete_one([], []).

delete_one([1|Tail], R):- delete_one(Tail, R).
delete_one([Head|Tail], [Head|R]):- Head \= 1, delete_one(Tail, R).


/*

translate_list_atoms_chars(+ListAtoms, -ListChars).

*/

translate_list_atoms_chars([], []).

translate_list_atoms_chars([Head|Tail], R2):-
  translate_list_atoms_chars(Tail, R),
  atom_chars(Head, RHead),
  append(RHead, R, R2).
