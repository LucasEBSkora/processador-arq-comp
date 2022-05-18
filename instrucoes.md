Todas instruções tem exatamente 15 bits

# NOP
## Descrição
  Faz nada.
## Formato Assembly
  `NOP`
## formato de instrução 
| opcode (14 a 11) |       (10 a 0)      |
|------------------|:-------------------:|
| `0000`           | indiferente         |

# ADD
## Descrição
  Soma um valor ao registrador acumulador A e armazena no acumulador. Pode somar valores imediatos, registradores ou memória.
## Formato Assembly
  * Soma com imediato: `ADD A #VALOR`, onde VALOR é um número com sinal de 9 bits
  * Soma com registrador: `ADD A (REGISTRADOR)`, onde REGISTRADOR é o nome ou número de um dos registradores
  * Soma com memória: `ADD A $ENDEREÇO`, onde ENDEREÇO é um valor de até 9 bits selecionando um endereço de RAM (ainda não implementado)
## Formato de instrução
| opcode (14 a 11) |   SEL (10 a 9)  | DADO                   |
|------------------|:---------------:|------------------------|
| `0001`           | Seleciona fonte | De onde retirar o dado |

onde:

| Descrição                                           |  SEL | DADO                                        |
|-----------------------------------------------------|:----:|---------------------------------------------|
| Retira dado da instrução                            | `00` | Número com sinal de 9 bits                  |
| Retira dado do registrador indicado                 | `01` | valor de 3 bits selecionando um registrador |
| Retira dado do endereço indicado (não implementado) | `10` | Endereço de 9 bits indicando posição na RAM |
| não usado - interpreta como imediato                | `11` | Número com sinal de 9 bits                  |

# SUB
## Descrição
  subtrai um valor do registrador acumulador A e armazena o resultado acumulador. Pode subtrair valores imediatos, registradores ou memória.
## Formato Assembly
  * Soma com imediato: `SUB A #VALOR`, onde VALOR é um número com sinal de 9 bits
  * Soma com registrador: `SUB A (REGISTRADOR)`, onde REGISTRADOR é o nome ou número do registrador.
  * Soma com memória: `SUB A $ENDEREÇO`, onde ENDEREÇO é um valor de até 9 bits selecionando um endereço de RAM (ainda não implementado)
## Formato de instrução
| opcode (14 a 11) |   SEL (10 a 9)  | DADO                   |
|------------------|:---------------:|------------------------|
| `0010`           | Seleciona fonte | De onde retirar o dado |



| Descrição                                           |  SEL | DADO                                        |
|-----------------------------------------------------|:----:|---------------------------------------------|
| Retira dado da instrução                            | `00` | Número com sinal de 9 bits                  |
| Retira dado do registrador indicado                 | `01` | valor de 3 bits selecionando um registrador |
| Retira dado do endereço indicado (não implementado) | `10` | Endereço de 9 bits indicando posição na RAM |
| não usado - interpreta como imediato                | `11` | Número com sinal de 9 bits                  |

# LD
## Descrição
  Move um dado de um registrador para outro.
## Formato Assembly
  `LD (DESTINO) (FONTE)`, onde DESTINO e FONTE são nomes ou números de registradores.
## Formato de instrução
| opcode (14 a 11) |   DESTINO(5 a 3) | FONTE(2 a 0)                   |
|------------------|:---------------:|------------------------|
| `0011`           | inteiro de 3 bits identificando o registrador de destino | inteiro de 3 bits identificando o registrador fonte|

Os bits de 10 a 6 não são usados.


# JA (Jump Absolute) 
## formato Assembly:
`JA ADDR`, onde `ADDR` é o endereço de 11 bits para pular incondicionalmente (substitui os bits menos significativos do program counter)
## formato de instrução:
| opcode (14 a 11) |     ADDR(10 a 0)    |
|------------------|:-------------------:|
| `1111`           | Endereço de 11 bits |