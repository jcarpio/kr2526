%---------------------------------------------------
% primesBetweenX_Y(+X, +Y, -ListR)
%  is true when ListR combines with a list
%  containing the primes from X to
%  Y, both inclusive, in ascending order.
%  ?- primesBetweenX_Y(1,8,R)
%  R=[1,2,3,5,7]
%  ?- primesBetweenX_Y(2,8,R)
%---------------------------------------------------

primesBetweenX_Y(X, X, []).
primesBetweenX_Y(X, Y, [X|R]):- X < Y, X2 is X+1, prime(X), primesBetweenX_Y(X2, Y, R). 
primesBetweenX_Y(X, Y, R):- X < Y, X2 is X+1, \+ prime(X), primesBetweenX_Y(X2, Y, R).

%------------------------------------------------
% list_div sors(+X, +Y, -ListR).
% is true when ListR unifies with a list
% containing the numbers whose remainder
% of the integer division of X by Z is equal to 0
% for values ​​of Z between 1 and Y.
/* list_divisors(8, 8, R). -> R [1,2,4,8]
                   |-> [1,2,3,4,5,6,7,8]

list_divisors(8, 7, R2). ->R2 [1,2,4]
                 |-> [1,2,3,4,5,6,7]
*/

list_divisors(_, 1, [1]).
list_divisors(X, Y, [Y|R]):- Y > 1, Y2 is Y-1, 0 is X mod Y, list_divisors(X, Y2, R).
list_divisors(X, Y, R):- Y > 1, Y2 is Y-1, Rest is X mod Y,
  Rest \= 0, list_divisors(X, Y2, R).

%---------------------------------------------------
% prime(+X)
% is True if X is a prime number.
%---------------------------------------------------

prime(X):- list_divisors(X, X, [_,_]).
