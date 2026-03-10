/*
  Information about the program we want to specify:
  
  my_reverse(+List, -ListR)
    is true when ListR unify with a list containing the
same elements of List but in reverse order.
 
  ? my_reverse([1,2,3,4,5], R).
  
  R = [5,4,3,2,1]


The methodology to resolve Prolog Problems.

Apply Induction.

1. P(n0)

I need a solution for the n0 (in case of list [] "empty list").
In order to get a solution, we only need to read the phrase of
the description for the predicate.

2. P(n-1) -> P(n)
   p(N) :- N2 is N-1, p(N2). 
   
 First, we have to separate [Head|Tail] and them we ask to "n-1" (Tail of the list)

 my_reverse([Head|Tail],  ):-  my_reverse(Tail, R)
 
 In the output of "n-1" we wrete a new new (a free variable, R). And now,
 the question is "What we have inside R?" or "What is the result for "n-1?".
 To answer the question, again I have to read the description phrase.
 
 
 Next question:"What I have to do the R to get the result for the full list?"
 
 my_reverse([Head|Tail], R2):-  my_reverse(Tail, R), append(R, [Head], R2).
 
 In this case, what we need to add to R is the Head at the end and we can do 
 that using append. 
 
 
 
   


  
*/  

my_reverse([], []).
my_reverse([Head|Tail], R2):- my_reverse(Tail, R), append(R, [Head], R2). 


/*
[1,2,3,4,5] -> [2,3,4,5] -> [5,4,3,2]

[5,4,3,2,1]
 


*/


