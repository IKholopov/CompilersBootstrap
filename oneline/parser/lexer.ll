%{
    #include <olc_lexer.h>
    using namespace OlcLex;

    #undef YY_DECL
    #define YY_DECL int OlcLex::OlcLexer::yylex(yy::parser::semantic_type* const value, yy::parser::location_type* location)
%}

%option c++
%option yyclass="OlcLexer"
%option noyywrap nounput noinput

SPACE   [ \t]+
CHAR    [A-Za-z_]
DIGITP  [1-9]
ZERO    0
DIGIT   {ZERO}|{DIGITP}
BIN_OP_MULT   [*/]
BIN_OP_ADD    [+\-]
BIN_OP_CMP  <=|>=|[<=>]

ID      {CHAR}({CHAR}|{DIGIT})*
INT_VAL ({DIGITP}({DIGIT})*|{ZERO})

%%
%{
           yylval = value;
           loc = location;
%}

"def"       { return Process(Token::DEF); }
"int"       { return Process(Token::INT); }
"list"      { return Process(Token::LIST); }
"."         { return Process(Token::DOT); }
"("         { return Process(Token::L_BRACE); }
")"         { return Process(Token::R_BRACE); }
"["         { return Process(Token::L_SQ_BRACE); }
"]"         { return Process(Token::R_SQ_BRACE); }
":"         { return Process(Token::COLON); }
","         { return Process(Token::COMMA); }
{BIN_OP_MULT}    { return Process(Token::BIN_OP_MULT); }
{BIN_OP_ADD}    { return Process(Token::BIN_OP_ADD); }
{BIN_OP_CMP}    { return Process(Token::BIN_OP_CMP); }
"if"        { return Process(Token::IF); }
"else"      { return Process(Token::ELSE); }
{ID}        { return Process(Token::NAME); }
{INT_VAL}   { return Process(Token::INT_CONST); }
\n[\n]+     { EmptyLine(); }
"\n"        { return Process(Token::NL); }
{SPACE}     { Space(); }
.           { Error(); }

%%

