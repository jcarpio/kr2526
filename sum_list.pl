
/*
Add all elements in a list

[1,2,3]

n0 for list (empty list) = []

[Head|Tail] = [1,2,3]

Head = 1
Tail = [2,3]

sum_list(List, Number)
 is true is Number unify with the sum of all 
 elements in List.
 
Induction
1. P(n0)
2. For all n>n0, P(n-1) -> P(n)

sum_list([Head|Tail], R):- sum_list(Tail, N), 
  R is N + Head. 
*/

sum_list([], 0).
sum_list([Head|Tail], R):- sum_list(Tail, N), 
  R is N + Head.
