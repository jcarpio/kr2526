
:- use_module(library(clpfd)).

add(X, Y, Z):- Z #= X + Y.


sudoku(Rows):- 
   length(Rows, 9),
   maplist(same_length(Rows), Rows),
   append(Rows, Vars), Vars ins 1..9,
   maplist(all_distinct, Rows),
   transpose(Rows, Cols),
   maplist(all_distinct, Cols),
   Rows = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
   blocks(As,Bs,Cs),
   blocks(Ds,Es,Fs),
   blocks(Gs,Hs,Is).   
   
blocks([],[],[]).
blocks([A,B,C|Tail1],[D,E,F|Tail2],[G,H,I|Tail3]):-
  all_distinct([A,B,C,D,E,F,G,H,I]),
  blocks(Tail1, Tail2, Tail3).

sudoku_1([  
[1, _, 3, 4, 5, 6, 7, 8, 9],
[4, 5, 6, _, 8, _, 1, _, 3],
[7, 8, _, 1, 2, 3, 4, 5, 6],
[2, _, 4, 3, _, 5, 8, _, 7],
[3, 6, _, _, 9, 7, _, 1, 4],
[8, _, 7, 2, _, 4, _, 6, _],
[5, _, 1, _, 4, _, 6, _, 2],
[6, 7, _, 5, _, 2, _, 4, 1],
[9, _, 2, _, 7, _, 5, _, 8]
]).
  