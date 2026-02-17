# Prolog: Exercise one

natural(N):- N > 1, N is N-1, natural(N2).
natural(1).
