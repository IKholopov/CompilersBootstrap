%require "3.2"
%language "c++"

%define api.value.type variant

%locations

%code requires{
    #include <tokentree.h>

    namespace OlcLex {
        class OlcLexer;
    }
}

%parse-param { OlcLex::OlcLexer& scanner }
%parse-param { TreeNodePtr& result }

%code {
    #include "olc_lexer.h"

#undef yylex
#define yylex scanner.yylex

Position toPos(const yy::location& from, const yy::location& to) {
    return Position{
        static_cast<int>(from.begin.line), static_cast<int>(to.end.line),
        static_cast<int>(from.begin.column), static_cast<int>(to.end.column)
    };
}

}

%token DEF
%token INT
%token LIST
%token DOT
%token L_BRACE
%token R_BRACE
%token L_SQ_BRACE
%token R_SQ_BRACE
%token COLON
%token COMMA
%token <std::string> BIN_OP_MULT
%token <std::string> BIN_OP_ADD
%token <std::string> BIN_OP_CMP
%token IF
%token ELSE
%token <std::string> NAME
%token <int64_t> INT_CONST
%token NL

%token END 0

%type <std::string> id
%type arg
%type type_decl
%type <TreeNodePtr> method_signature
%type <TreeNodePtr> method
%type <TreeNodePtr> method_list
%type program
%type <TreeNodePtr> exp
%type <TreeNodePtr> exp_list

%left NL
%left IF
%left ELSE
%left BIN_OP_CMP
%left BIN_OP_ADD
%left BIN_OP_MULT
%left DOT
%left L_SQ_BRACE

%%

program
    : method_list END       { result = $1; }
    | method_list NL END    { result = $1; }

arg
    : id type_decl    {  }

type_decl
    : INT       { }
    | LIST      { }

method_signature
    : DEF id                                 { $$ = MakeSeq({ MakeValue("def"), MakeValue($2) }); }
    | DEF id L_BRACE arg R_BRACE             { $$ = MakeSeq({ MakeValue("def"), MakeValue($2) }); }

method
    : method_signature COLON NL exp           { $$ = MakeSeq({ $1, MakeValue(":"), $4 }); }
    | method_signature type_decl COLON NL exp { $$ = MakeSeq({ $1, MakeValue(":"), $5 }); }

method_list
    : method                    { $$ = $1; }
    | method_list method        { $$ = MakeSeq({ $1, $2 }); }

id
    : NAME   { $$ = $1; }

exp_list
    : exp COMMA exp         { $$ = MakeSeq({ $1, MakeValue(","), $3 }); }
    | exp_list COMMA exp    { $$ = MakeSeq({ $1, MakeValue(","), $3 });}

exp
    : L_SQ_BRACE exp_list R_SQ_BRACE        { $$ = MakeSeq({ MakeValue("["), $2, MakeValue("]") }); }
    | L_SQ_BRACE exp R_SQ_BRACE             { $$ = MakeSeq({ MakeValue("["), $2, MakeValue("]") }); }
    | L_SQ_BRACE R_SQ_BRACE                 { $$ = MakeSeq({ MakeValue("["), MakeValue("]") }); }
    | exp IF exp ELSE exp                   { $$ = MakeSeq({ $1, MakeValue("if"), $3, MakeValue("else"), $5 });  }
    | exp BIN_OP_MULT exp                   { $$ = MakeSeq({ $1, MakeValue($2), $3 }); }
    | exp BIN_OP_ADD exp                    { $$ = MakeSeq({ $1, MakeValue($2), $3 }); }
    | exp BIN_OP_CMP exp                    { $$ = MakeSeq({ $1, MakeValue($2), $3 }); }
    | exp DOT id L_BRACE exp_list R_BRACE   { $$ = MakeSeq({ $1, MakeValue("."), MakeValue($3), MakeValue("("), $5, MakeValue(")") }); }
    | exp DOT id                            { $$ = MakeSeq({ $1, MakeValue("."), MakeValue($3)}); }
    | exp DOT id L_BRACE exp R_BRACE        { $$ = MakeSeq({ $1, MakeValue("."), MakeValue($3), MakeValue("("), $5, MakeValue(")") }); }
    | id                                    { $$ = MakeValue($1); }
    | INT_CONST                             { $$ = MakeValue(std::to_string($1)); }
    | exp L_SQ_BRACE exp R_SQ_BRACE         { $$ = MakeSeq({ $1, MakeValue("["), $3, MakeValue("]") }); }
    | exp L_SQ_BRACE exp COLON R_SQ_BRACE   { $$ = MakeSeq({ $1, MakeValue("["), $3, MakeValue(":"), MakeValue("]") }); }
    | L_BRACE exp R_BRACE                   { $$ = MakeSeq({ MakeValue("("), $2, MakeValue(")") }); }
%%

void yy::parser::error (const location_type& l, const std::string& m) {
    std::cerr << m << " at " << l << std::endl;
}
