% co-authored by Matthew Drahozal, James Clemer, Jeannie Tran
% Consultancy: Cait Hakala, on the nature of Bitchiness
% 10 self-esteem points
% 1. public communication
% 2. note-passing?
% 3. choose action:
% -> Verbal Attack
% -> Group Attack
% -> Defend

% representing social momentum
% there's always this one girl no matter the social group, that everyone wants to be friends with. People are constantly fighting for the top girl, no matter her worth as a prize.
% some girls turn bitchy, some do not- quoth Caitlin Hakala
:- discontiguous(agent/1, self_esteem/2, current_action/2).
:- dynamic (agent/1, self_esteem/2, current_action/2, expectsBecause/3).



initialize:-
  retractall(self_esteem(_, _)),
  retractall(agent(_)),
  retractall(current_action(_, _)),
  maplist(assert,
[agent(veronicaMars),
  self_esteem(veronicaMars, 25),
  current_action(veronicaMars, default),
agent(cady),
  self_esteem(cady, 10),
  current_action(cady, default),
agent(regina),
  self_esteem(regina, 10),
  current_action(regina, default),
agent(janis),
  self_esteem(janis, 10),
  current_action(janis, default),
agent(karen),
  self_esteem(karen,10),
  current_action(karen, default),
agent(sharon),
  self_esteem(sharon, 10),
  current_action(sharon, default),
agent(veronica),
  self_esteem(veronica, 10),
  current_action(veronica, default),
agent(heather_duke),
  self_esteem(heather_duke, 10),
  current_action(heather_duke, default),
agent(heather_chandler),
  self_esteem(heather_chandler, 10),
  current_action(heather_chandler, default),
agent(heather_mcnamara),
  self_esteem(heather_mcnamara, 10),
  current_action(heather_mcnamara, default)
  ]).

run_turn:-
  bagof(Agent, agent(Agent), Agents),
  generate_communication_list(Communiques, Agents), 
  execute_turn(Communiques),
  generate_action_list(ActionList, Agents),
  execute_turn(ActionList),
  (maybe_kill(Agents); true),
  (maybe_win(Agents); true).

maybe_win([AgentH|AgentT]):-
  length([AgentH|AgentT], 1) -> print("GAME OVER! THE WINNER IS ~w", AgentH).

maybe_win([]):-
  print("GAME OVER! YOU ALL LOSE! THIS IS WHY WE CAN'T HAVE NICE THINGS!").

generate_action_list([],[]).
generate_action_list(Action_List, [Agent|Rest_Agents]):-
	append([Agent:Action], Rest_Actions, Action_List),
	choose_action(Agent, Action),
	generate_action_list(Rest_Actions, Rest_Agents).

execute_turn([]).
execute_turn([Agent:Action|Tail]):-
	call(Action),
	execute_turn(Tail).

% Agents with 0 health DIE. or CHANGE SKOOLS.
% OR SOMETHING!
% BUT THEY TOTALLY LOSE!
maybe_kill([]).
maybe_kill([AgentsH|AgentsT]):-
  (maybe_kill(AgentsH);true),
  maybe_kill(AgentsT).
maybe_kill(Agent):-
  self_esteem(Agent, X),
  X < 0.5 -> (retract(agent(Agent)),
              retract(self_esteem(Agent, _)),
              retract(current_action(Agent, _))).

choose_action(Agent, group_attack(Agent, regina)):-
  % Communicate
	retract(current_action(Agent,_)),
	assertz(current_action(Agent, group_attack(Agent, regina))).
%%	obviously this will be more fully-fledged
%       but that's kind of the crux of the game
%	so i'm postponing it for now


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

attack(Assailant, Victim):-
  self_esteem(Assailant, _), self_esteem(Victim, Num),
  (   current_action(Victim, defend) ->
         New is Num - 1/2;
    New is Num - 1),
  retract(self_esteem(Victim, Num)),
  assertz(self_esteem(Victim, New)).

group_attack(Assailant, Victim):-
  findall(Aggressor, current_action(Aggressor, group_attack(Aggressor, Victim)), Pack),
  self_esteem(Assailant, X),
  self_esteem(Victim, Y),
  length(Pack, Length),
  ( Length = 1 ->
  (   NewX is X - 2,
      retract(self_esteem(Assailant, X)),
      asserta(self_esteem(Assailant, NewX)));
  ( Length > 1 ->
    (current_action(Victim, defend) -> Delta is 1; Delta is 2),
    (   NewY is Y - Delta,
      retract(self_esteem(Victim, Y)),
      asserta(self_esteem(Victim, NewY))))).

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
