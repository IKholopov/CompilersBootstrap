#include <iostream>

#include "olc_lexer.h"

int main(int argc, const char* argv[]) {
    bool usePos = argc <= 1 || argv[1] != std::string("--nopos");
    OlcLex::OlcLexer lexer{&std::cout, usePos};
    try {
        while(lexer.yylex() != 0) {
        }
    } catch (std::runtime_error& e) {
        std::cerr << "\x1B[31m" << e.what() << "\x1B[0m" << std::endl;
    }
    return 0;
}
