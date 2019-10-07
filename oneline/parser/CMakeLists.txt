# Build lexer

file(GLOB Lexer_SRC lexer.ll)
file(GLOB Parser_SRC olc_lexer.cpp)
file(GLOB Bison_SRC parser.yy)

set(parser_INC ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR} CACHE STRING "parser inc dir")

flex_target(olc_lexer_flex ${Lexer_SRC} ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.cc)
bison_target(olc_parser_bison ${Bison_SRC} ${CMAKE_CURRENT_BINARY_DIR}/parser.cc)

add_flex_bison_dependency(olc_lexer_flex olc_parser_bison)

file(GLOB parser_sripts "*.sh")

add_library(olc_parser
        ${Parser_SRC}
	${FLEX_olc_lexer_flex_OUTPUTS}
        ${BISON_olc_parser_bison_OUTPUTS}
)
target_include_directories(olc_parser PUBLIC "." ${CMAKE_CURRENT_BINARY_DIR} ${FLEX_INCLUDE_DIRS})

add_executable(olc-lexprint lexprint.cpp)
target_link_libraries(olc-lexprint olc_parser)

add_executable(olc-parseprint parseprint.cpp)
target_link_libraries(olc-parseprint olc_parser)

file(COPY ${parser_sripts} DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
