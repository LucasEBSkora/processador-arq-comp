//obs: Como os registradores de uso geral vão de t0 a t3, mapeamos R3 para t0, R4 para t1, e R5 para t2.

//NOP
NOP //B"0000_00_000_000000"

//JRxx - JRC (Carry) - (Também é testado o ADD com constante e o LD com registrador)
LD A, t0 //B"0011_00_101_000000"
ADD A,#$1000000000
JRC teste

//JRxx - JREQ (Equal) - (Também é testado o ADD e CP com endereço)
LD A,t0 //B"0011_00_101_000000"
ADD A,$1000
CP A, $1000
JREQ teste

//JRxx - JRMI (Minus/Negativo) - (Também é testado o ADD com registrador)

LD A,t0 //B"0011_00_101_000000"
ADD A,#$-1
LD t1, A
ADD A, t1
LD A, t1
JRMI teste

//JRxx - JRNC (Not Carry)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$1
JRC teste

//JRxx - JRNE (Not Equal) - (Também é testado o CP com registrador e o LD com endereço)
LD A,t0 //B"0011_00_101_000000"
ADD A, #$2
LD t1, A
LD A, $1000
CP A, t1
JREQ teste

//JRxx - JRNV (not Overflow)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$-6
JRC teste

//JRxx - JRPL (not Positive)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$-6
JRC teste

//JRxx - JRSGE (Greater or Equal)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$-6
CP A, #$-6
JRC teste
ADD A,#$1
CP A, #$-6
JRC teste

//JRxx - JRSGT (Greater than)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$-6
CP A, #$-8
JRC teste

//JRxx - JRSLE (Less or Equal)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$-6
CP A, #$-6
JRC teste
SUB A,#$-1
CP A, #$-6
JRC teste


//JRxx - JRSLT (Less than)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$-8
CP A, #$-6
JRC teste

//JRxx - JRUGE (Unsigned Greater or Equal)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$6
CP A, #$6
JRC teste
ADD A,#$1
CP A, #$6
JRC teste

//JRxx - JRUGT (Unsigned Greater than)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$6
CP A, #$4
JRC teste

//JRxx - JRULE (Unsigned Less or Equal)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$-6
CP A, #$-6
JRC teste
SUB A,#$-1
CP A, #$-6
JRC teste


//JRxx - JRSLT (Unsigned Less than)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$4
CP A, #$6

//JRxx - JRV (Overflow)
LD A,t0 //B"0011_00_101_000000"
ADD A,#$-9999
CP A, #$6

//JRxx - JRT (True)
JRT teste

//JRxx - JRF (False)
JRF teste

//Feito só pra verificar se as condicionais do JRxx estão funcionando
label teste 
LD A, t2
ADD A, #$55

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
