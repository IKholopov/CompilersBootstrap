#include <iostream>

#include "olc_lexer.h"

int main() {
    OlcLex::OlcLexer lexer;

    yy::parser parser(lexer);

    try {
        if( parser.parse() ) {
            return 1;
        }
    } catch (std::exception& e) {
        std::cerr << "\x1B[31m" << e.what() << "\x1B[0m" << std::endl;
    }
    return 0;
}
