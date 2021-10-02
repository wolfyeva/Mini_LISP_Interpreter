# Mini_LISP_Interpreter
大三-Compiler Final Project


如何編譯執行:

bison -d -o FP1.tab.c FP1.y

gcc -c -g -I.. FP1.tab.c

flex -o lex.yy.c FP1.l

gcc -c -g -I.. lex.yy.c

gcc -o FP1 FP1.tab.o lex.yy.o -ll

./FP1<input.txt


簡述你的設計:

● 程式語言： lex/yacc

● Basic Feature

1. Syntax Validation
2. Print
3. Numerical Operations
4. Logical Operations
5. if Expression
6. Variable Definition

● Bonus Feature
1. Type Checking

● Error message

    ○ 1.重覆定義範例：

        (define x 1)

        (define x 2)

        輸出：

        Redefining is not allowed.

    ○ 2.未宣告變數範例：

        (print-num (+ a b))

        輸出：

        Symbol not defined: a
