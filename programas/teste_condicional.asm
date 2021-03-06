//obs: Como os registradores de uso geral vão de t0 a t3, mapeamos R3 para t0, R4 para t1, e R5 para t2.

//1. Carrega R3 (o registrador 3) com o valor 0
LD t0,#$0 //B"0011_00_100_000000"

//2. Carrega R4 com 0
LD t1,#$0 //B"0011_00_101_000000"

//3. Soma R3 com R4 e guarda em R4
label terceira_instrucao
LD A, t0 //B"0011_01_001_000_100"
ADD A,t1 //B"0001_01_000000_101"
LD t1, A //B"0011_01_101_000_001"

//4. Soma 1 em R3
LD A, t0 //B"0011_01_001_000_100"
ADD A, #$1 //B"0001_00_000000001"
LD t0, A //B"0011_01_100_000_001"

//5. Se R3<30 salta para instrução do passo 3
LD A, t0  //B"0011_01_001_000_100"
SUB A, #$30 //B"0010_00_000011110"
JRSLT terceira_instrucao  //B"1110_1010_1111000"

//6. Copia valor de R4 para R5
LD t2, t1 //B"0011_01_110_000_101"

Que seria traduzido para o seguinte programa:
B"0011_00_100_000000"
B"0011_00_101_000000"
B"0011_01_001_000_100"
B"0001_01_000000_101"
B"0011_01_101_000_001"
B"0011_01_001_000_100"
B"0001_00_000000001"
B"0011_01_100_000_001"
B"0011_01_001_000_100"
B"0010_00_000011110"
B"1110_1010_1111000"
B"0011_01_110_000_101"