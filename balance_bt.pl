

/*

create_bt(+List, -Tree)
  is true if Tree unify with a binary tree will all labels in List.
  Tree have to be balanced.

*/


create_bt([], nil).
create_bt([Head|List], a(RLeft, RRight) ):-
  length(List, L), Div is L div 2,
  length(Left, Div),
  append(Left, Right, List),
  create_bt(Left, RLeft), create_bt(Right, RRight).







/*

balanced(+Tree)
  is true if for all nodes in Tree the difference
  between left and right tall is maximum 1 in absolute value.
 
*/


balanced(nil).

balanced(t(_, Left, Right)):-
  tree_tall(Left, Left_tall),
  tree_tall(Right, Right_tall),
  Diff is Left_tall - Right_tall,
  Abs is abs(Diff), Abs =< 1,
  balanced(Left), balanced(Right).
 
/* 
tree_tall(+Tree, -Tall)
 is true if Tall unify with Tree's tall.

*/

tree_tall(nil, 0).

tree_tall( t(_, Left, Right), T):-
  tree_tall(Left, Tall_left),
  tree_tall(Right, Tall_right),
  T is max(Tall_left, Tall_right) + 1. 
 



