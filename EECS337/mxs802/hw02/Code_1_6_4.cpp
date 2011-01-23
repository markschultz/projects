# 1 "../hw01/Code_1_6_4.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "../hw01/Code_1_6_4.c"
# 19 "../hw01/Code_1_6_4.c"
int x = 2;
void b() { x = (x+1); printf("%d\n", x); }
void c() { int x = 1; printf("%d\n", (x+1)); }
void main() { b(); c(); }
