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
:-include('acts.pl').
:-include('communication.pl').
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
  ]),
  bagof(Agent, agent(Agent), Agents),
  maplist(allStartingTrust, Agents).

startingTrust(Agent, Other):-
  random(0, 100, Num),
  retractall(trust(Agent, Other, _)),
  assert(trust(Agent, Other, Num)).

allStartingTrust(Agent):-
  bagof(Other, (agent(Other), Other \= Agent), Others),
  maplist(startingTrust(Agent), Others).

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

