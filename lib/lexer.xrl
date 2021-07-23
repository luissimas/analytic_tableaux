Definitions.

ATOM          = [a-z]
WHITESPACE    = [\s\t\n\r]
AND           = \&
OR            = \|
NOT           = \!
IMPLIES       = \-\>

Rules.

{ATOM}        : {token, {atom, TokenLine, TokenChars}}.
\(            : {token, {'(', TokenLine}}.
\)            : {token, {')', TokenLine}}.
{AND}         : {token, {'and', TokenLine}}.
{OR}          : {token, {'or', TokenLine}}.
{NOT}         : {token, {'not', TokenLine}}.
{IMPLIES}     : {token, {'implies', TokenLine}}.
{WHITESPACE}+ : skip_token.

Erlang code.
