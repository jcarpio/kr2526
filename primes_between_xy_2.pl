%---------------------------------------------------
% primes_between_xy(+X, +Y, -ListR)
%  is true when ListR combines with a list
%  containing the primes from X to
%  Y, both inclusive, in ascending order.
%  ?- primes_between_xy(1,8,R)
%  R=[1,2,3,5,7]
%  ?- primes_between_xy(2,8,R)
%---------------------------------------------------

primes_between_xy(X, X, [X]):- prime(X).
primes_between_xy(X, X, []):- \+ prime(X).

primes_between_xy(X, Y, [X|R]):- X < Y, X2 is X+1, prime(X), primes_between_xy(X2, Y, R).

primes_between_xy(X, Y, R):- X < Y, X2 is X+1, \+ prime(X), primes_between_xy(X2, Y, R).

%------------------------------------------------
% list_divisors(+X, +Y, -ListR).
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

list_divisors(X, Y, R):- Y > 1, Y2 is Y-1, \+ 0 is X mod Y, list_divisors(X, Y2, R).



%---------------------------------------------------
% prime(+X)
% is True if X is a prime number.
%---------------------------------------------------

prime(X):- list_divisors(X, X, [X, 1]).
