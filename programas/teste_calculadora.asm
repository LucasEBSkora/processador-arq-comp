//obs: Como não há registradores de uso geral mapeamos R3 para $3, R4 para $4, e R5 para $5 na RAM.

//1. Carrega R3 (o registrador 3) com o valor 5
LD A,#$5 // 0 => B"011_00_1_000000101"
LD $3,A  // 1 => B"011_01_0_000000011"

//2. Carrega R4 com 8
LD A,#$8 // 2 => B"011_00_1_000001000"
LD $4,A  // 3 => B"011_01_0_000000100"

//3. Soma R3 com R4 e guarda em R5
label terceira_instrucao
LD A,$3  // 4 => B"011_01_1_000000011"
ADD A,$4 // 5 => B"001_01_0000000100"
LD $5,A  // 6 => B"011_01_0_000000101"

//4. Subtrai 1 de R5 - Instruções não ortogonais: apenas o A faz subtração
LD A,$5   // 7 => B"011_01_1_000000101"
SUB A,#$1 // 8 => B"010_00_0000000001"
LD $5,A   // 9 => B"011_01_0_000000101"

//5. Salta para o endereço 20
JP endereco_20 // 10 => B"110_000000010100"

//6. No endereço 20, copia R5 para R3
label endereco_20
LD A,$5 // 20 => B"011_01_1_000000101"
LD $3,A // 21 => B"011_01_0_000000011"

//7. Salta para a terceira instrução desta lista (R5 <= R3+R4)
JP terceira_instrucao // 22 => B"110_000000000100"

Que seria traduzido para o seguinte programa:
0 => B"011_00_1_000000101",
1 => B"011_01_0_000000011",
2 => B"011_00_1_000001000",
3 => B"011_01_0_000000100",
4 => B"011_01_1_000000011",
5 => B"001_01_0000000100",
6 => B"011_01_0_000000101",
7 => B"011_01_1_000000101",
8 => B"010_00_0000000001",
9 => B"011_01_0_000000101",
10 => B"110_000000010100",
20 => B"011_01_1_000000101",
21 => B"011_01_0_000000011",
22 => B"110_000000000100",