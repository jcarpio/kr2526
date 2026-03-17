%-----------------------------------------------------
% insert_sort(+List, -SortedList)
% True when SortedList unifies with a list that
% contains the same elements as List ordered
% from smallest to largest.
%-----------------------------------------------------

insert_sort([], []).

insert_sort([Head|Tail], R2):- insert_sort(Tail, R), insert_in_sorted_list(Head, R, R2). 



%-----------------------------------------------------
% insert_in_sorted_list(+Elem, +List, -ResultList)
% True when ResultList unifies with a list that
% contains the elements of the ordered list List
% with the element Elem inserted in order.
%-----------------------------------------------------

insert_in_sorted_list(Elem, [], [Elem]).

insert_in_sorted_list(Elem, [Head|Tail], [Elem, Head|Tail]):- Elem =< Head.

insert_in_sorted_list(Elem, [Head|Tail], [Head|R]):- Elem > Head, 
   insert_in_sorted_list(Elem, Tail, R).