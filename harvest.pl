/* =========================================================
   Berry Harvest Scheduler — CLP(FD) / SWI-Prolog
   Methodology: Markus Triska, "The Power of Prolog"
   (https://www.metalevel.at/prolog)

   PROBLEM DESCRIPTION
   -------------------
   We have N batches of berries (same species), each batch
   ripening on a different day (optimal_maturation_day).
   A delivery takes 7 days, so each batch MUST be harvested
   exactly 7 days before its optimal maturation day so the
   client receives the fruit in perfect condition.

   Each day at most W workers are available; each worker
   can harvest exactly CAP_PER_WORKER units per day.
   => daily capacity = W * CAP_PER_WORKER units

   The client has a delivery schedule: on certain days they
   need a specific number of units.  We must plan which
   batches to harvest (and on which day) to fulfil every
   order.

   VARIABLES
   ---------
   For every batch i:
     HarvestDay[i]  — integer day on which batch i is harvested
                      Domain: [maturation_day(i) - 7]
                      (forced to exactly one value by the biology)

   For each delivery deadline d with demand X:
     We need sum of batch_yield for all batches harvested
     on or before (d - 7) >= X.

   CONSTRAINTS (Triska-style, purely relational)
   --------------------------------------------
   1. Harvest-window:   HarvestDay[i] #= MatDay[i] - 7
      (each batch has exactly one valid harvest day)

   2. Daily capacity:   for each day D,
        sum of batch_yield[i] where HarvestDay[i]=D
        #=< W * CAP_PER_WORKER

   3. Delivery fulfilment:  for each order (DelivDay, Qty),
        sum of batch_yield[i] where HarvestDay[i] =< DelivDay-7
        #>= Qty

   4. Labeling: ff (fail-first) heuristic as recommended by Triska
      for scheduling problems.
   =========================================================
*/

:- use_module(library(clpfd)).

% ---------------------------------------------------------
% DATA  — edit these facts to match your actual farm data
% ---------------------------------------------------------

% batch(+Id, +OptimalMaturationDay, +YieldUnits)
% Days are numbered from 1 (start of the season).
% Example: 12 batches ripening across a ~60-day season.
batch(b01,  14,  80).
batch(b02,  16,  60).
batch(b03,  21,  90).
batch(b04,  23,  70).
batch(b05,  28, 100).
batch(b06,  30,  85).
batch(b07,  35,  75).
batch(b08,  37,  95).
batch(b09,  42,  80).
batch(b10,  44,  65).
batch(b11,  50,  90).
batch(b12,  55, 110).

% workers(+NumWorkers)
workers(6).

% capacity_per_worker(+UnitsPerDay)
capacity_per_worker(30).       % each worker harvests 30 units/day

% transit_days(+Days)   — delivery takes this many days
transit_days(7).

% order(+DeliveryDay, +RequiredUnits)
% The client needs RequiredUnits to ARRIVE on DeliveryDay.
% => we must have harvested them by DeliveryDay - transit_days.
order(25,  140).
order(35,  200).
order(50,  250).
order(65,  300).

% ---------------------------------------------------------
% CORE SOLVER
% ---------------------------------------------------------

%% harvest_schedule(-Schedule)
%
%  Schedule is a list of batch(Id, HarvestDay, Yield) terms,
%  one for each batch, satisfying all constraints.

harvest_schedule(Schedule) :-
    % 1. Collect all batch data
    findall(batch(Id, Mat, Yield),
            batch(Id, Mat, Yield),
            Batches),

    % 2. Build variable list and fix harvest days
    transit_days(Transit),
    maplist(harvest_day_var(Transit), Batches, HarvestDays),

    % 3. Capacity constraint: for every day, total harvested
    %    that day must not exceed W * CapPerWorker
    workers(W),
    capacity_per_worker(Cap),
    DailyCap #= W * Cap,
    daily_capacity_constraints(Batches, HarvestDays, DailyCap),

    % 4. Delivery constraints
    findall(ord(DD, Qty), order(DD, Qty), Orders),
    maplist(delivery_constraint(Batches, HarvestDays, Transit),
            Orders),

    % 5. Labeling — ff heuristic (Triska recommendation)
    labeling([ff], HarvestDays),

    % 6. Build readable solution
    build_schedule(Batches, HarvestDays, Schedule).


%% harvest_day_var(+Transit, +batch(Id,Mat,Yield), -Day)
%
%  Each batch has EXACTLY ONE valid harvest day: Mat - Transit.
%  We express this as a CLP(FD) constraint (relational style).

harvest_day_var(Transit, batch(_Id, Mat, _Yield), Day) :-
    Day #= Mat - Transit.


%% daily_capacity_constraints(+Batches, +HarvestDays, +DailyCap)
%
%  For every distinct possible harvest day D:
%    sum of yields of batches whose HarvestDay = D  #=<  DailyCap
%
%  We use reification (#<==>) to express "batch i is harvested on D".

daily_capacity_constraints(Batches, HarvestDays, DailyCap) :-
    % Collect all possible harvest days (ground, from data)
    transit_days(Transit),
    findall(D, (batch(_, Mat, _), D is Mat - Transit), PossibleDays0),
    sort(PossibleDays0, PossibleDays),
    maplist(one_day_cap(Batches, HarvestDays, DailyCap), PossibleDays).

one_day_cap(Batches, HarvestDays, DailyCap, Day) :-
    pairs_keys_values(Pairs, Batches, HarvestDays),
    % For each batch, yield if harvested on Day else 0
    maplist(yield_on_day(Day), Pairs, Contributions),
    sum(Contributions, #=<, DailyCap).

yield_on_day(Day, batch(_Id, _Mat, Yield)-HD, Contribution) :-
    % Reified: Contribution = Yield if HD=Day, else 0
    (HD #= Day) #<==> B,
    Contribution #= B * Yield.


%% delivery_constraint(+Batches, +HarvestDays, +Transit, +ord(DD,Qty))
%
%  All batches harvested by (DD - Transit) must sum to >= Qty.

delivery_constraint(Batches, HarvestDays, Transit, ord(DD, Qty)) :-
    Cutoff #= DD - Transit,
    pairs_keys_values(Pairs, Batches, HarvestDays),
    maplist(yield_by_cutoff(Cutoff), Pairs, Contributions),
    sum(Contributions, #>=, Qty).

yield_by_cutoff(Cutoff, batch(_Id, _Mat, Yield)-HD, Contribution) :-
    % Reified: harvested on or before Cutoff?
    (HD #=< Cutoff) #<==> B,
    Contribution #= B * Yield.


%% build_schedule(+Batches, +HarvestDays, -Schedule)

build_schedule([], [], []).
build_schedule([batch(Id,_Mat,Yield)|Bs], [HD|HDs],
               [sched(Id, HD, Yield)|Rest]) :-
    build_schedule(Bs, HDs, Rest).


% ---------------------------------------------------------
% PRETTY PRINTER
% ---------------------------------------------------------

%% print_schedule/0  — top-level query

print_schedule :-
    ( harvest_schedule(Schedule) ->
        format("~n=== Berry Harvest Schedule ===~n"),
        format("~w~t~30|~w~t~45|~w~n",
               ["Batch", "Harvest Day", "Yield (units)"]),
        format("~`-t~50|~n"),
        maplist(print_batch, Schedule),
        format("~`-t~50|~n"),
        check_orders(Schedule),
        format("~n")
    ;
        format("~nNo feasible schedule found.~n"),
        format("Check batch yields vs. order demands and daily capacity.~n")
    ).

print_batch(sched(Id, Day, Yield)) :-
    format("~w~t~30|Day ~d~t~45|~d~n", [Id, Day, Yield]).

check_orders(Schedule) :-
    transit_days(Transit),
    findall(ord(DD,Qty), order(DD,Qty), Orders),
    format("~n=== Delivery Order Check ===~n"),
    maplist(check_one_order(Schedule, Transit), Orders).

check_one_order(Schedule, Transit, ord(DD, Required)) :-
    Cutoff is DD - Transit,
    include(harvested_by(Cutoff), Schedule, Harvested),
    sumlist_yield(Harvested, Total),
    ( Total >= Required ->
        Status = "OK"
    ;
        Status = "SHORTFALL"
    ),
    format("Delivery day ~d: need ~d, available ~d  [~w]~n",
           [DD, Required, Total, Status]).

harvested_by(Cutoff, sched(_, Day, _)) :- Day =< Cutoff.

sumlist_yield([], 0).
sumlist_yield([sched(_,_,Y)|Rest], Total) :-
    sumlist_yield(Rest, T0),
    Total is T0 + Y.


% ---------------------------------------------------------
% ENTRY POINT
% ---------------------------------------------------------
%
%  Load in SWI-Prolog and run:
%    ?- print_schedule.
%
%  Or to get the raw solution term:
%    ?- harvest_schedule(S), maplist(writeln, S).
