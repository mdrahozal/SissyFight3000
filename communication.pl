/*
  The code for communicating in SF3K
  communications set up an expectation
  if the expectation is met, trust should rise
  if not, trust should fall
  trust determines whether or not an expectation is taken into account in 
  choosing actions.

*/


% reason about who each agent should communicate with, and what they should communicate.
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
  assert(expectsFrom(Audience, Proposition, Testifier)).

