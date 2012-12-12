generate_communication_list([], []).
generate_communication_list(Communiques, [Agent|Rest_Agents]):-
 append([Agent:Communique], Rest_Communiques, Communiques),
 choose_communication(Agent, Communique),
 generate_communication_list(Rest_Communiques, Rest_Agents).

% tell an audience of 1+ members that a proposition will happen.
% the audience then knows to watch for its veracity
tell(Testifier, Audience, Proposition):-
  maplist(addExpectation(Testifier, Proposition), Audience).

% expects(Testifier, Proposition, Agent).
addExpectation(Testifier, Proposition, Audience):-
  assert(expectsBecause(Audience, Proposition, Testifier)).

%% affinity(+Person, -AffinityLevel)
% True if SelfEsteem is the amount this character likes themselves.
:- public affinity/2.
affinity(Person, SelfEsteem) :-
	random_float(0, 1, SelfEsteem),
	asserta((affinity(Person, SelfEsteem):- !)),
	!.

:- public set_affinity/2.
set_affinity(Person,Level) :-
	person(Person),
	(retract(affinity(Person, _)) ; true),
	asserta((affinity(Person, Level):- !)),
	!.
