latest(Scores, Latest):- append(_, [Latest], Scores). 
personal_best(Scores, Best):- msort(Scores, Sort), reverse(Sort, [Best|_]).

personal_top_three(Scores, TopThree):- length(Scores, L), L > 3, msort(Scores, Sort), reverse(Sort, Reverse),
  length(TopThree, 3), append(TopThree, _, Reverse).
  
personal_top_three(Scores, R2):- length(Scores, L), L =< 3, msort(Scores, R), reverse(R, R2).
