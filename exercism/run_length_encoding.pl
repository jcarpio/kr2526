
encode(Plaintext, Ciphertext):- 
   string_chars(Plaintext, CharList),
   my_zip(CharList, ZippedList),
   create_string(ZippedList, Ciphertext).
   
/*   
decode(Ciphertext, Plaintext).
*/

%------------------------------------------
% my_zip(+ , -ListR)
%  is true if ListR unify with a list with
%  following structure
%
%  my_zip([a,a,b,b,b,c,d,d,a], R)
%  R= [(a,2), (b,3), (c,1), (d,2), (a,1)]
%
%   my_zip([a,b,b,b,c,d,d,a], R)
%   R= [(a,1), (b,3), (c,1), (d,2), (a,1)]


% my_zip([a,b,b,b,c,d,d,a], R)
%  R= [(a,1), (b,3), (c,1), (d,2), (a,1)]
 
% my_zip([b,b,b,c,d,d,a], R)
% R = [(b,3), (c,1), (d,2), (a,1)]

% 0000011000001000000011
% [(0,5),(1,2), (1,1), (0,7), (1,2)]
% [0-5,1-2, 1-1, 0-7, 1-2]

%------------------------------------------
my_zip([], []).

my_zip([Elem], [1-Elem]).

my_zip([Head, Head|Tail], [N2-Elem|R]  ):-  
  my_zip([Head|Tail], [N-Elem|R]), N2 is N + 1.

my_zip([Head1, Head2|Tail],  [1-Head1|R]):- 
  Head1 \= Head2, my_zip([Head2|Tail], R).
  
/*  
create_string(+List, -R)
 is true if R unify with a list with this format:
 create_string([12-'W', 1-'B', 12-'W'], R).
 R = "WWWWWWWWWWWWBWWWWWWWWWWWW"

*/

create_string([], "").

create_string([N-Elem|Tail], R2):-
  create_string(Tail, R),
  create_elem_string(N, Elem, String),
  string_concat(String, R, R2).
  
/*

create_elem_string(N, Elem, R)
  is true if R unify with a string with this format:
  repeat_string(3, W, R).
  R = "3W" 
  repeat_string(1, B, R).
  R = "B"   
  
*/

create_elem_string(N, Elem, R2):- N > 1, number_chars(N, NList), 
  atom_chars(Elem, ElemList),
  append(NList, ElemList, R),
  string_chars(R2, R).

create_elem_string(1, Elem, R2):- atom_chars(Elem, R), string_chars(R2, R).


/* decode(+SmallString, -BigString)
   is true if BigString unify with a list in this format:
   decode("12WB12W3B24WB", R).
   R = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB"
*/

decode(SmallString, R2):- string_chars(SmallString, SmallChars),
      create_sub_lists(SmallChars, R), decode_list(R, R2).

/*
   decode_list_pairs(+SmallString, -BigString)
   is true if BigString unify with a list in this format:
   decode_list_pairs([1,2,'W','B',1,2,'W',3,'B',2,4,'W','B'], R).
   R = [12-W, 1-B, 12-W, 3-B, 24-W, 1-B]
*/



is_number_char(Char):- char_code(Char, N), N >= 48, N =< 57.

/*
create_sub_lists(+CharList, -R)
  es cierto si R unifica con una lista con el siguiente formato:
  create_sub_lists([1,2,'W','B',1,2,'W',3,'B',2,4,'W','B'], R)
  R =[ [1,2], ['W'], ['B'], [1,2], ['W'], [3], ['B'], [2,4], ['W'], ['B']]  
*/

create_sub_lists([], []).

create_sub_lists([Elem], [[Elem]]).

create_sub_lists([Head1, Head2|Tail], [[Head1|List]|R]):- is_number_char(Head1, Head2), 
 create_sub_lists([Head2|Tail], [List|R]).
 
create_sub_lists([Head1, Head2|Tail], [[Head1]|R]):- \+ is_number_char(Head1, Head2),
 create_sub_lists([Head2|Tail], R).
 
is_number_char(Char1, Char2):- is_number_char(Char1), is_number_char(Char2). 
  
 
decode_list([], "").
decode_list([Char], R):- string_chars(R, Char).
decode_list([[Head1|Tail1], [Head2]|Tail], R):- is_number_char(Head1), 
                                      number_chars(N, [Head1|Tail1]),
									  create_string_repeat(N, Head2, HeadString),
									  decode_list(Tail, TailString),
									  string_concat(HeadString, TailString, R).
									  
decode_list([[Head1]|Tail], R):- \+ is_number_char(Head1), 
						  string_chars(HeadString, [Head1]),
						  decode_list(Tail, TailString),
						  string_concat(HeadString, TailString, R).                       
				
							
is_number_list([Head|_]):- is_number_char(Head).							

/*
create_string_repeat(+N, +Char, -String).
  is true if String unify with String with following format:
  create_string_repeat(3, 'W', String).
  String = "WWW"
*/

create_string_repeat(1, Char, R):- string_chars(R, [Char]).
create_string_repeat(N, Char, R):- N > 1, N2 is N-1,
  create_string_repeat(N2, Char, StringTail),
  string_chars(StringHead, [Char]),
  string_concat(StringHead, StringTail, R).


