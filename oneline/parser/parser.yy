%require "3.2"
%language "c++"

%define api.value.type variant

%locations

%code requires{
    namespace OlcLex {
        class OlcLexer;
    }
}

%parse-param { OlcLex::OlcLexer& scanner }

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
%token SEMI
%token COMMA
%token <std::string> BIN_OP
%token IF
%token ELSE
%token <std::string> NAME
%token <int64_t> INT_CONST
%token NL

%token END 0

%type <std::string> id
%type arg
%type type_decl
%type method_signature
%type method
%type method_list
%type program
%type exp
%type exp_list

%left NL
%left IF
%left ELSE
%left BIN_OP

%%

program
    : method_list END       {  }
    | method_list NL END    {  }

arg
    : id type_decl    {  }

type_decl
    : INT       { }
    | LIST      { }

method_signature
    : DEF id                                 {  }
    | DEF id L_BRACE arg R_BRACE             {  }

method
    : method_signature SEMI NL exp           {  }
    | method_signature type_decl SEMI NL exp {  }

method_list
    : method                    {  }
    | method_list method        {  }

id
    : NAME   { $$ = $1; }

exp_list
    : exp COMMA exp         { }
    | exp_list COMMA exp    { }

exp
    : L_SQ_BRACE exp_list R_SQ_BRACE        { }
    | L_SQ_BRACE exp R_SQ_BRACE             { }
    | L_SQ_BRACE R_SQ_BRACE                 { }
    | exp IF exp ELSE exp                   { std::cerr << "if else" << std::endl;  }
    | exp BIN_OP exp                        { std::cerr << $2 << std::endl; }
    | exp DOT id L_BRACE exp_list R_BRACE   { }
    | exp DOT id                            { std::cerr << "call " << $3 << "()" << std::endl; }
    | exp DOT id L_BRACE exp R_BRACE        { }
    | id                                    { }
    | INT_CONST                             { }
    | exp L_SQ_BRACE exp R_SQ_BRACE         { }
    | exp L_SQ_BRACE exp SEMI R_SQ_BRACE    { }
    | L_BRACE exp R_BRACE                   { }
%%

void yy::parser::error (const location_type& l, const std::string& m) {
    std::cerr << m << " at " << l << std::endl;
}
