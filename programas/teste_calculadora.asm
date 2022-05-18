//obs: Como os registradores de uso geral vão de t0 a t3, mapeamos R3 para t0, R4 para t1, e R5 para t2.

//1. Carrega R3 (o registrador 3) com o valor 5
LD (t0) #5

//2. Carrega R4 com 8
LD (t1) #8

//3. Soma R3 com R4 e guarda em R5
label terceira_instrucao
LD (A) #0
ADD A t0
ADD A t1
LD (t2) (A)

//4. Subtrai 1 de R5 - Instruções não ortogonais: apenas o A faz subtração
LD (A) (t2)
SUB A #1
LD (t2) (A)

//5. Salta para o endereço 20
JA endereco_20
//6. No endereço 20, copia R5 para R3
label endereco_20
LD (t0) (t2)

//7. Salta para a terceira instrução desta lista (R5 <= R3+R4)
JA terceira_instrucao

Que seria traduzido para o seguinte programa:
B"0011_00_100_000101"
B"0011_00_101_001000"
B"0011_00_001_000000"
B"0001_01_000000_100"
B"0001_01_000000_101"
B"0011_01_110_000001"
B"0011_01_001_000110"
B"0010_00_000000001"
B"0011_01_110_000001"
B"1111_00000010100"
B"0000_00000000000"
B"0000_00000000000"
B"0000_00000000000"
B"0000_00000000000"
B"0000_00000000000"
B"0000_00000000000"
B"0000_00000000000"
B"0000_00000000000"
B"0000_00000000000"
B"0000_00000000000"
B"0011_01_100_000_110"
B"1111_00000000011"
