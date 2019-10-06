#include <iostream>

#include "olc_lexer.h"

int main() {
    OlcLex::OlcLexer lexer{&std::cout};
    try {
        while(lexer.yylex() != 0) {
        }
    } catch (std::runtime_error& e) {
        std::cerr << "\x1B[31m" << e.what() << "\x1B[0m" << std::endl;
    }
    return 0;
}
