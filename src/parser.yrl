Nonterminals formula operator.
Terminals '(' ')' atom 'and' 'or' 'not' 'implies'.
Rootsymbol formula.

formula  -> atom                     : value('$1').
formula  -> '(' formula ')'          : '$2'.
formula  -> operator formula         : {'$1', '$2'}.
formula  -> formula operator formula : {'$2', '$1', '$3'}.
operator -> 'and'                    : value('$1').
operator -> 'or'                     : value('$1').
operator -> 'not'                    : value('$1').
operator -> 'implies'                : value('$1').

Erlang code.

value({_Token, _Line, Value}) -> Value;
value({Value, _Line}) -> Value.
