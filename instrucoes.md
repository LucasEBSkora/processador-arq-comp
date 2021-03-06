Todas instruções tem exatamente 15 bits. Temos 4 registradores:
  * Z: registrador carregado sempre com constante 0;
  * A: Acumulador, único capaz de operações de soma e subtração;
  * X e Y: Registradores de índice, acessam memória 
  * Embora não seja acessível exceto pela instrução JRxx, há um registrador de estados que guarda informações sobre a última operação. As flags guardadas são:
    * Overflow(V): houve overflow na última operação aritmética com sinal;
    * Negative(N): a última operação - mesmo se de movimentação de dados apenas - teve resultado negativo;
    * Zero(Z): a última operação - mesmo se de movimentação de dados apenas - teve resultado zero;
    * Carry(C): A última operação aritmética gerou carry

Como discutido com o professor, as instruções do STM8 possuem muitos modos de endereçamento. Por isso, as instruções usadas foram implementadas apenas parcialmente, com alguns modos de endereçamento. A pasta "instrucoes" contém prints do datasheet do processador-base, com setas vermelhas indicando grosso modo as opções e modos de endereçamento implementados para cada instrução.

# NOP
## Descrição
  Faz nada.
## Formato Assembly
  `NOP`
## Formato de instrução 
| opcode (14 a 12) |       (11 a 0)      |
|------------------|:-------------------:|
| `000`            | indiferente         |
## Flags afetadas
Nenhuma.

# ADD
## Descrição
  Soma um valor ao registrador acumulador A e armazena o resultado no acumulador. Pode somar valores imediatos ou memória com endereço fixo ou por ponteiro.
## Formato Assembly
  * Soma com imediato: `ADD A,#$VALOR`, onde VALOR é um número com sinal de 10 bits
  * Soma com memória: `ADD A,$ENDEREÇO`, onde ENDEREÇO é um valor de até 10 bits selecionando um endereço de RAM 
  * Soma indireta: `ADD A,(REGISTRADOR)`, onde REGISTRADOR é X ou Y
## Formato de instrução
| opcode (14 a 12) |   SEL (11 a 10) | DADO (9 a 0)           |
|------------------|:---------------:|------------------------|
| `001`            | Seleciona fonte | De onde retirar o dado |

onde:

| Descrição                                                  |  SEL | DADO                                        |
|------------------------------------------------------------|:----:|---------------------------------------------|
| Retira dado da instrução                                   | `00` | Número com sinal de 10 bits                 |
| Retira dado do endereço indicado                           | `01` | endereço de 10 bits                         |
| Retira dado do endereço indicado pelo registrador X        | `10` |                  don't care                 |
| Retira dado do endereço indicado pelo registrador Y        | `11` |                  don't care                 |

## Flags afetadas:
Sendo A14-A0 os bits do registrador A, M14-0 os bits do outro operando, E R14-0 os bits do resultado:
  * V : `(A14*M14 + M14*!R14 + !R14*A14) XOR (A13*M13 + M13*!R13 + !R13*A13)`
  * N : `R14`
  * Z : `R = 0`
  * C : `A14*M14 + M14*!R14 + !R14*A14`

# SUB
## Descrição
  subtrai um valor do registrador acumulador A e armazena o resultado no acumulador. Pode somar valores imediatos ou memória com endereço fixo ou por ponteiro.
## Formato Assembly
  * Soma com imediato: `SUB A,#$VALOR`, onde VALOR é um número com sinal de 10 bits
  * Soma com memória: `SUB A,$ENDEREÇO`, onde ENDEREÇO é um valor de até 10 bits selecionando um endereço de RAM
  * Soma indireta: `SUB A,(REGISTRADOR)`, onde REGISTRADOR é X ou Y
## Formato de instrução
| opcode (14 a 12) |   SEL (11 a 10) | DADO (9 a 0)           |
|------------------|:---------------:|------------------------|
| `010`            | Seleciona fonte | De onde retirar o dado |

onde:

| Descrição                                                  |  SEL | DADO                                        |
|------------------------------------------------------------|:----:|---------------------------------------------|
| Retira dado da instrução                                   | `00` | Número com sinal de 10 bits                 |
| Retira dado do endereço indicado                           | `01` | endereço de 10 bits                         |
| Retira dado do endereço indicado pelo registrador X        | `10` |                  don't care                 |
| Retira dado do endereço indicado pelo registrador Y        | `11` |                  don't care                 |


## Flags afetadas:
Sendo A14-A0 os bits do registrador A, M14-0 os bits do outro operando, E R14-0 os bits do resultado:
  * V : `(A14*M14 + A14*R14 + A14*M14*R14) XOR (A13*M13 + A13*R13 + A13*M13*R13)`
  * N : `R14`
  * Z : `R = 0`
  * C : `!A14*M14 + !A14*R14 + A14.M14.R14`

# LD
## Descrição
  Carrega o registrador A com o valor do registrador X ou Y, um valor imediato, ou um valor na memória (endereçado de forma fixa ou por ponteiro);
## Formato Assembly
  * Imediato para acumulador: `LD A,#$VALOR`, onde VALOR é um número com sinal de 6 bits.
  * Memória para acumulador: `LD A,$ENDEREÇO`, onde ENDEREÇO é um endereço sem sinal de até 6 bits.
  * Acumulador para memória: `LD $ENDEREÇO, A`, onde ENDEREÇO é um valor de até 6 bits selecionando um endereço de RAM.
  * Memória por ponteiro para acumulador: `LD A,(FONTE)`, onde FONTE é X ou Y.
  * Registrador para acumulador: `LD A, REGISTRADOR`, onde REGISTRADOR é X ou Y.
  * Acumulador para memória por ponteiro: `LD (DESTINO), A`, onde DESTINO é X ou Y.
  * Acumulador para registrador: `LD REGISTRADOR, A`, onde REGISTRADOR é X ou Y.
## Formato de instrução
| opcode (14 a 12) |       SEL (11 a 10)                | POSICAO (9)                            | DADO (8 a 0)               |
|------------------|:----------------------------------:|----------------------------------------|----------------------------|
| `011`            | Seleciona tipo do segundo operador | `0` se A é a fonte, `1` se é o destino | De onde o valor é retirado |

onde:

| Descrição                                                  |  SEL | DADO                                                                          |
|------------------------------------------------------------|:----:|-------------------------------------------------------------------------------|
| Retira dado da instrução                                   | `00` | Número com sinal de 9 bits                                                    |
| Retira dado do endereço indicado                           | `01` | endereço de 9 bits                                                            |
| Retira dado do registrador X                               | `10` | `0` se o registrador é usado como valor, `1` se como endereço                 |
| Retira dado do registrador Y                               | `11` | `0` se o registrador é usado como valor, `1` se como endereço                 |

A combinação POSICAO = `0` e SEL = `00` não tem efeito.

## Flags afetadas:
Sendo R14-0 os bits escritos no destino:
  * N : `R14`
  * Z : `R = 0`
As flags C e V não são alteradas.

# JRxx (Jump Relative) 
## Descrição
Pula somando o parâmetro ao valor do PC se uma condição verificada no registrador de estados é verdadeira.
## Formato Assembly:
`JRxx OFFSET`, onde `xx` é o tipo de condição e `OFFSET` é o offset para fazer o pulo relativo;
## Formato de instrução:
| opcode (14 a 12) |   xx(11 a 8) |        OFFSET(7 a 0)      |
|------------------|:------------:|:-------------------------:|
| `101`            |   Condição   | Offset com sinal de 8 bits|

onde

| Verificação sobre a última operação                                            | xx     | Mnemônico | Condição verificada no registrador |
|--------------------------------------------------------------------------------|--------|-----------|------------------------------------|
| Verifica se houve Carry                                                        | `0000` | JRC       | `C = 1`                            |
| Verifica se os operandos eram iguais                                           | `0001` | JREQ      | `Z = 1`                            |
| Verifica se o resultado era negativo                                           | `0010` | JRMI      | `N = 1`                            |
| Verifica se não houve Carry                                                    | `0011` | JRNC      | `C = 0`                            |
| Verifica se os operandos eram diferentes                                       | `0100` | JRNE      | `Z = 0`                            |
| Verifica se não houve overflow                                                 | `0101` | JRNV      | `V = 0`                            |
| Verifica se o resultado era não negativo                                       | `0110` | JRPL      | `N = 0`                            |
| Verifica se o operando da esquerda era maior ou igual ao da direita, com sinal | `0111` | JRSGE     | `(N XOR V) = 0`                    |
| Verifica se o operando da esquerda era maior que o da direita, com sinal       | `1000` | JRSGT     | `Z OR (N XOR V)) = 0`              |
| Verifica se o operando da esquerda era menor ou igual ao da direita, com sinal | `1001` | JRSLE     | `(Z OR (N XOR V)) = 1`             |
| Verifica se o operando da esquerda era menor que o da direita, com sinal       | `1010` | JRSLT     | `(N XOR V) = 1 `                   |
| Verifica se o operando da esquerda era maior ou igual ao da direita, sem sinal | `0011` | JRUGE     | `C = 0`                            |
| Verifica se o operando da esquerda era maior que o da direita, sem sinal       | `1011` | JRUGT     | `C = 0 AND Z = 0`                  |
| Verifica se o operando da esquerda era menor ou igual ao da direita, sem sinal | `1100` | JRULE     | `C = 1 OR Z = 1`                   |
| Verifica se o operando da esquerda era menor que o da direita, sem sinal       | `0000` | JRULT     | `C = 1`                            |
| Verifica se houve overflow                                                     | `1101` | JRV       | `V = 1`                            |
| Sempre pula                                                                    | `1110` | JRT       | true                               |
| Nunca pula                                                                     | `1111` | JRF       |  false                             |

OBS: As operações de comparação (JREQ, JRNE, JRSGE, JRSGT, JRSLE, JRSLT, JRUGE, JRUGT, JRULE, JRULT) só mantém seu comportamento "semântico" se a última operação foi uma subtração (SUB) ou comparação (ADD) entre os valores que se desejava comparar.

## Flags afetadas
Nenhuma.

# JP (Jump Absolute)
## Descrição
"Pula" setando o PC para o endereço passado.
## Formato Assembly:
`JP ADDR`, onde `ADDR` é o endereço de 12 bits para pular incondicionalmente (substitui os bits menos significativos do program counter)
## Formato de instrução:
| opcode (14 a 12) |     ADDR(11 a 0)    |
|------------------|:-------------------:|
| `110`            | Endereço de 12 bits |

## Flags afetadas
Nenhuma.


# CP
## Descrição
  Compara um valor com o valor armazenado no registrador acumulador A sem alterar o acumulador. Pode comparar com valores imediatos ou memória (por endereço constante ou ponteiro). Efetivamente, subtrai o valor de A sem alterá-lo.
## Formato Assembly
  * Comparação com imediato: `CP A,#$VALOR`, onde VALOR é um número com sinal de 10 bits
  * Comparação com memória: `CP A,$ENDEREÇO`, onde ENDEREÇO é um valor de até 10 bits selecionando um endereço de RAM
  * Comparação indireta: `CP A,(REGISTRADOR)`, onde REGISTRADOR é X ou Y
## Formato de instrução
| opcode (14 a 12) |   SEL (11 a 10) | DADO (9 a 0)           |
|------------------|:---------------:|------------------------|
| `111`            | Seleciona fonte | De onde retirar o dado |

onde:

| Descrição                                                  |  SEL | DADO                                        |
|------------------------------------------------------------|:----:|---------------------------------------------|
| Retira dado da instrução                                   | `00` | Número com sinal de 10 bits                 |
| Retira dado do endereço indicado                           | `01` | endereço de 10 bits                         |
| Retira dado do endereço indicado pelo registrador X        | `10` |                  don't care                 |
| Retira dado do endereço indicado pelo registrador Y        | `11` |                  don't care                 |


## Flags afetadas:
Sendo A14-A0 os bits do registrador A, M14-0 os bits do outro operando, e R14-0 os bits do resultado:
  * V : `(A14*M14 + A14*R14 + A14*M14*R14) XOR (A13*M13 + A13*R13 + A13*M13*R13)`
  * N : `R14`
  * Z : `R = 0`
  * C : `!A14*M14 + !A14*R14 + A14.M14.R14`
