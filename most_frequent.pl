

%------------------------------------------
% most_frequent(+List, -Elem, -Num)
%
% most_frequent([a,a,b,b,b,c,d,d,a], Elem, N).
% Elem = a
% N = 3
%------------------------------------------


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

my_zip([Elem], [(Elem,1)]).

my_zip([Head, Head|Tail], [(Elem,N2)|R]  ):-  
  my_zip([Head|Tail], [(Elem,N)|R]), N2 is N + 1.

my_zip([Head1, Head2|Tail],  [(Head1,1)|R]):- 
  Head1 \= Head2, my_zip([Head2|Tail], R).
