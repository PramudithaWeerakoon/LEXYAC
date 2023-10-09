cmake_minimum_required(VERSION 3.23)
project(0_7)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)
include_directories(.idea)

add_executable(0_7
        .idea/.gitignore
        .idea/0.7.iml
        .idea/modules.xml
        .idea/workspace.xml
        calc.l
        calc.tab.c
        calc.tab.h
        calc.y
        calculator
        lex.yy.c)
