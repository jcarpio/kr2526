%-----------------------------------------------------
% bubble_sort(+List, -ListR).
% it is true when ListR unifies with a list containing the 
% same elements as List ordered from lowest to highest.
%-----------------------------------------------------

bubble_sort(List, List):- sorted(List).

bubble_sort(List, R2):- append(L1, [Elem1, Elem2|L2], List),
                       Elem1 > Elem2,
                       append(L1, [Elem2, Elem1|L2], R),
					   bubble_sort(R, R2).					   
					   
%-----------------------------------------------------------------
% sorted(+List)
%  is true if elements in List are sorted from howest to highest.
%-----------------------------------------------------------------

sorted([]).
sorted([_]).
sorted([Elem1, Elem2|Tail]):- Elem1 =< Elem2, sorted([Elem2|Tail]).


