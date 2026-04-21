
:- set_prolog_flag(double_quotes, chars).

my_zip([], []).

my_zip([Elem], [(Elem,1)]).

my_zip([Head, Head|Tail], [(Elem,N2)|R]  ):-  
  my_zip([Head|Tail], [(Elem,N)|R]), N2 is N + 1.

my_zip([Head1, Head2|Tail],  [(Head1,1)|R]):- 
  Head1 \= Head2, my_zip([Head2|Tail], R).
  
encode(String, R5):- my_zip(String, R), translate(R, R2), delete_one(R2, R3),
  translate_list_atoms_chars(R3, R4), 
  string_chars(R5, R4).


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
  
  
/*
decode("2AB3CD4E",  "AABCCCDEEEE").


"B3CD4E" -> "BCCCDEEEE"

"B3CD4E" -> "BCCCDEEEE" -> 

*/

decode(String, R2):- string_chars(String, List), decode_list(List, R),
                   string_chars(R2, R).

decode_list([], []).

decode_list([N, Elem|Tail], R3):- atom_number(N, N2), number(N2),
  decode_list(Tail, R),
  repeat(N2, Elem, R2),
  append(R2, R, R3).

decode_list([Elem|Tail], [Elem|R]):- \+ atom_number(Elem, Elem),
  decode_list(Tail, R).

  
/*  
repeat(+Number, +Elem, -R)  
  is true if R unify with a list in this format
  
  repeat(3, a, R)
  R = [a,a,a]

*/

repeat(1, Elem, [Elem]).

repeat(N, Elem, [Elem|R]):- N > 1,  N2 is N-1, repeat(N2, Elem, R).  