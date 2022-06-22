
//NOP
NOP //0 => B"000_000000000000",

//JP
//para frente
JP #$5 //1 => B"110_000000000101",
NOP //2 => B"000_000000000000",
JP #$6 //3 => B"110_000000000110",
NOP //4 => B"000_000000000000",
//para trás
JP #$3 //5 => B"110_000000000011",

//LD
// load de imediato para A (A = -10)
LD A,#$-10 // 6 => B"011_00_1_111110110",
// load de acumulador para endereço fixo (endereço 37 = -10)
LD $37,A // 7 => B"011_01_0_000100101",

// load de acumulador para registrador (X = 37)
LD A,#$37 // 8 => B"011_00_1_000100101",
LD X,A // 9 => B"011_10_0_000000000",

// load de acumulador para endereço por ponteiro  (A = -10)
LD A,(X) // 10 => B"011_10_1_000000001",

// load de endereço por ponteiro para memória (endereço 25 = 25)
LD A,#$25 // 11 => B"011_00_1_000011001",
LD Y,A // 12 => B"011_11_0_000000000",
LD (Y),A // 13 => B"011_11_0_000000001",

// memória fixa para acumulador (A = -10)
LD A,$37 // 14 => B"011_01_1_000100101",

// registrador para endereço de memória (A = 25)
LD A,Y // 15 => B"011_11_1_000000000",

//ADD
// soma com imediato (A = 10)
LD A,#$0 // 16 => B"011_00_1_000000000",
ADD A,#$10 // 17 => B"001_00_0000001010",

// soma com endereço de memória (A = 0)
LD A,#$-50 // 18 => B"011_00_1_111001110",
LD $10,A // 19 => B"011_01_0_000001010",
LD A,#$50 // 20 => B"011_00_1_000110010",
ADD A,$10 // 21 => B"001_01_0000001010",

// soma com endereço por ponteiro (A = 30)
LD A,#$20 // 22 => B"011_00_1_000010100",
LD X,A // 23 => B"011_10_0_000000000",
LD A,#$35 // 24 => B"011_00_1_000100011",
LD (X),A // 25 => B"011_10_0_000000001",
LD A,#$-5 // 26 => B"011_00_1_111111011",
ADD A,(X)  // 27 => B"001_10_0000000000",

//SUB/CP
// subtração de imediato (A = 27)
LD A,#$80 // 28 => B"011_00_1_001010000",
CP A,#$53 // 29 => B"111_00_0000110101",
SUB A,#$53 // 30 => B"010_00_0000110101",

// subtração de endereço de memória (A = 67)
LD A,#$-17 // 31 => B"011_00_1_111101111",
LD $10,A  // 32 => B"011_01_0_000001010",
LD A,#$50 // 33 => B"011_00_1_000110010",
CP A,$10 // 34 => B"111_01_0000001010",
SUB A,$10 // 35 => B"010_01_0000001010",

// subtração de endereço por ponteiro (A = -5)
LD A,#$100 // 36 => B"011_00_1_001100100",
LD Y,A // 37 => B"011_11_0_000000000",
LD A,#$-5 // 38 => B"011_00_1_111111011",
LD (Y),A // 39 => B"011_11_0_000000001",
LD A,#$-10 // 40 => B"011_00_1_111110110",
CP A,(Y)  // 41 => B"111_11_0000000000",
SUB A,(Y) // 42 => B"010_11_0000000000",


Que seria traduzido para o seguinte programa:
0 => B"000_000000000000",
1 => B"110_000000000101",
2 => B"000_000000000000",
3 => B"110_000000000110",
4 => B"000_000000000000",
5 => B"110_000000000011",
6 => B"011_00_1_111110110",
7 => B"011_01_0_000100101",
8 => B"011_00_1_000100101",
9 => B"011_10_0_000000000",
10 => B"011_10_1_000000001",
11 => B"011_00_1_000011001",
12 => B"011_11_0_000000000",
13 => B"011_11_0_000000001",
14 => B"011_01_1_000100101",
15 => B"011_11_1_000000000",
16 => B"011_00_1_000000000",
17 => B"001_00_0000001010",
18 => B"011_00_1_111001110",
19 => B"011_01_0_000001010",
20 => B"011_00_1_000110010",
21 => B"001_01_0000001010",
22 => B"011_00_1_000010100",
23 => B"011_10_0_000000000",
24 => B"011_00_1_000100011",
25 => B"011_10_0_000000001",
26 => B"011_00_1_111111011",
27 => B"001_10_0000000000",
28 => B"011_00_1_001010000",
29 => B"111_00_0000110101",
30 => B"010_00_0000110101",
31 => B"011_00_1_111101111",
32 => B"011_01_0_000001010",
33 => B"011_00_1_000110010",
34 => B"111_01_0000001010",
35 => B"010_01_0000001010",
36 => B"011_00_1_001100100",
37 => B"011_11_0_000000000",
38 => B"011_00_1_111111011",
39 => B"011_11_0_000000001",
40 => B"011_00_1_111110110",
41 => B"111_11_0000000000",
42 => B"010_11_0000000000",