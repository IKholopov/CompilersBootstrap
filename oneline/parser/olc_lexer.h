#pragma once

#include <ostream>
#include <memory>

// Some magic for FlexLexer.h
#if !defined (yyFlexLexerOnce)
#include <FlexLexer.h>
#endif // _!defined (yyFlexLexerOnce)
#include <parser.hh>

using Token = yy::parser::token::yytokentype;

struct Position {
    int lineFrom = 0;
    int lineTo = 0;
    int colFrom = 0;
    int colTo = 0;
};

namespace OlcLex {

class OlcLexer : public yyFlexLexer {
public:
    OlcLexer() = default;
    explicit OlcLexer(std::ostream* debug_print, bool printPosition=true)
        : debug(debug_print),
          printPos(printPosition) {
    }

    int yylex(yy::parser::semantic_type* const value=nullptr, yy::parser::location_type* location=nullptr);

private:
    yy::parser::semantic_type* yylval = nullptr;
    yy::parser::location_type* loc = nullptr;

    int lineNumber = 1;
    int colNumber = 1;
    std::ostream* debug = nullptr;
    bool printPos = true;

    int Process(Token token);
    int EmptyLine();
    void Space();
    [[noreturn]]
    void Error();

    void DebugPrint(Token token) const;
    void DebugPrintNewLine() const;
    void DebugPrint(Token token, std::string attribute) const;
    void DebugPrint(Token token, int64_t attribute) const;
    void PrintToken(Token token) const;
    void PrintSpace(Token token) const;
    std::string FormattedPosition() const;

    template<typename T>
    void Build(const T& value) {
        if (yylval == nullptr) {
            return;
        }
        yylval->build<T>(value);
    }
};

} // OlcLexl
