#include "olc_lexer.h"

#include <unordered_map>
#include <string>

namespace OlcLex {

static const std::unordered_map<Token, const char*> TokenNames = {
    {Token::DEF, "DEF"},
    {Token::INT, "INT"},
    {Token::LIST, "LIST"},
    {Token::DOT, "DOT"},
    {Token::L_BRACE, "L_BRACE"},
    {Token::R_BRACE, "R_BRACE"},
    {Token::L_SQ_BRACE, "L_SQ_BRACE"},
    {Token::R_SQ_BRACE, "R_SQ_BRACE"},
    {Token::SEMI, "SEMI"},
    {Token::COMMA, "COMMA"},
    {Token::BIN_OP_0, "BIN_OP_0"},
    {Token::BIN_OP_1, "BIN_OP_1"},
    {Token::BIN_OP_2, "BIN_OP_2"},
    {Token::IF, "IF"},
    {Token::ELSE, "ELSE"},
    {Token::NAME, "NAME"},
    {Token::INT_CONST, "INT_CONST"},
    {Token::NL, "NL"}
};

std::string TokenToName(Token token) {
    return TokenNames.at(token);
}

int OlcLexer::Process(Token token)
{
    switch (token) {
    case Token::INT_CONST: {
            int64_t value = std::stoll(YYText());
            DebugPrint(token, value);
            Build(value);
        }
        break;
    case Token::NAME: {
            std::string value = YYText();
            DebugPrint(token, value);
            Build(value);
        }
        break;
    case Token::BIN_OP_0:
    case Token::BIN_OP_1:
    case Token::BIN_OP_2: {
            std::string operation = YYText();
            DebugPrint(token, operation);
            Build(operation);
        }
        break;
    default:
        DebugPrint(token);
        break;
    }

    if (loc != nullptr) {
        loc->begin.line = static_cast<unsigned int>(lineNumber);
        loc->begin.column = static_cast<unsigned int>(colNumber);
    }
    if (token == Token::NL) {
        lineNumber += 1;
        colNumber = 1;
    } else {
        colNumber += YYLeng();
    }
    if (loc != nullptr) {
        loc->end.line = static_cast<unsigned int>(lineNumber);
        loc->end.column = static_cast<unsigned int>(colNumber);
    }

    return token;
}

int OlcLexer::EmptyLine()
{
    int result = Process(Token::NL);
    lineNumber += YYLeng() - 1;
    colNumber = 1;
    return result;
}

void OlcLexer::Space()
{
    colNumber += YYLeng();
}

void OlcLexer::Error()
{
    throw std::runtime_error("Unknown lexem: " + std::string(YYText()) + " at" + FormattedPosition());
}

std::string OlcLexer::FormattedPosition() const
{
    return "(" + std::to_string(lineNumber) + "," + std::to_string(colNumber) + ")";
}

void OlcLexer::DebugPrint(Token token) const
{
    if (debug == nullptr) {
        return;
    }
    PrintToken(token);
    PrintLine();
}

void OlcLexer::DebugPrint(Token token, std::string attribute) const
{
    if (debug == nullptr) {
        return;
    }
    PrintToken(token);
    *debug << "{" << attribute << "}";
    PrintLine();
}

void OlcLexer::DebugPrint(Token token, int64_t attribute) const
{
    if (debug == nullptr) {
        return;
    }
    PrintToken(token);
    *debug << "{" << attribute << "}";
    PrintLine();
}

void OlcLexer::PrintToken(Token token) const
{
    *debug << TokenToName(token);
}

void OlcLexer::PrintLine() const
{
    *debug << FormattedPosition() << std::endl;
}

}