/* the code for generating and executing 'physical' acts in the SF3K world.
   namely, the code for attacking, group attacking, defending, and deciding which to do.
   NOTE: defend does not need code, as it's practically inert.
*/

generate_action_list([],[]).
generate_action_list(Action_List, [Agent|Rest_Agents]):-
	append([Agent:Action], Rest_Actions, Action_List),
	choose_action(Agent, Action),
	generate_action_list(Rest_Actions, Rest_Agents).

choose_action(Agent, group_attack(Agent, regina)):-
  % Communicate
	retract(current_action(Agent,_)),
	assertz(current_action(Agent, group_attack(Agent, regina))).
%%	obviously this will be more fully-fledged
%       but that's kind of the crux of the game
%	so i'm postponing it for now



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

