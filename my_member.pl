/*
Information for arguments in SWI Prolog Documentation

? : Free or instantiated
+ : Instantiated is needed
- : Free is needed

my_member(?Elem, ?List)
  is true if Elem is a member of List
  
Induction
1. P(n0)
2. For all n>n0, P(n-1) -> P(n)
  
*/

my_member(Elem, [Elem|_]).
my_member(Elem, [_|Tail]):- my_member(Elem,Tail).