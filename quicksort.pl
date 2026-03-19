%-----------------------------------------------------
% division(+Elem, +List, -Smaller, -Larger)
%   is true when Smaller unifies with a list containing
%   the elements of List that are less than or equal
%   to Elem, and Larger unifies with a list containing
%   the elements of List that are greater than Elem.
%-----------------------------------------------------

division(_, [], [], []).

division(Pivot, [Head|Tail ],  [Head|Lower], Higher):- Head =< Pivot,
  division(Pivot, Tail, Lower, Higher).
  
division(Pivot, [Head|Tail ],  Lower, [Head|Higher]):- Head > Pivot,
  division(Pivot, Tail, Lower, Higher).  
  
  
/*  
quicksort(+List, -ListR).  
 true when ListR unifies with a list that
 contains the same elements as List sorted
 from lowest to highest.
*/

quicksort([],[]).

quicksort([Pivot|Tail], R):-
   division(Pivot, Tail, Lower, Higher),
   quicksort(Lower, RLower),
   quicksort(Higher, RHigher),
   append(RLower, [Pivot|RHigher], R).
