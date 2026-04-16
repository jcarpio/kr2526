/*

abbreviate(Sentence, Acronym).
  is true when Acronym unify with a string with this format:
  
  abbreviate("Rolling On The Floor Laughing So Hard That My Dogs Came Over And Licked Me", Acronym).
  Acronym == "ROTFLSHTMDCOALM".
  
  abbreviate("Something - I made up from thin air", Acronym).
  Acronym == "SIMUFTA".
  
  abbreviate("Halley's Comet", Acronym).
  Acronym == "HC".
  
  
  abbreviate("The Road _Not_ Taken", Acronym).
  Acronym == "TRNT".

*/
:- use_module(library(lists)).
:- use_module(library(charsio)).

abbreviate(String, [Char|R2]):- string_chars(String, List), 
   remove_repetitions(List, [Head|List2]), \+ blank(Head),
   to_upper(Head, R), char_code(Char, R),
   abbreviate_list(List2, R2).
   
abbreviate(String, R2):- string_chars(String, List), 
   remove_repetitions(List, [Head|List2]), blank(Head),
   abbreviate_list([Head|List2], R2).   

blank(' ').
blank('-').
blank('_').

remove_repetitions([],[]).
remove_repetitions([Elem], [Elem]).
remove_repetitions([Head, Head|Tail], R):- remove_repetitions([Head|Tail], R).
remove_repetitions([Head1, Head2|Tail], [Head1|R]):- Head1 \= Head2, 
   remove_repetitions([Head2|Tail], R).

abbreviate_list([], []).
abbreviate_list([_], []).
abbreviate_list(List, R3):-
  append(List1, [Elem1, Elem2|List2], List),
  blank(Elem1),
  abbreviate_list(List1, R1),
  abbreviate_list(List2, R2),
  to_upper(Elem2, R), char_code(Char, R),
  append(R1, [Char|R2], R3).
  
abbreviate_list([Head|Tail], [Char]):- no_blank([Head|Tail]), to_upper(Head, R), char_code(Char, R).

no_blank([]).
no_blank([Elem]):- \+ blank(Elem).
no_blank([Head|Tail]):- \+ blank(Head), no_blank(Tail).

  