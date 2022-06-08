Todas instruções tem exatamente 15 bits. Temos 8 registradores:
  * Z: registrador carregado sempre com constante 0;
  * A: Acumulador, único capaz de operações de soma e subtração;
  * X e Y: Registradores de índice, acessam memória 
  * t0 a t3: Registradores de "uso geral"
  * Embora não seja acessível exceto pela instrução JRxx, há um registrador de estados que guarda informações sobre a última operação. As flags guardadas são:
    * Overflow(V): houve overflow na última operação aritmética com sinal;
    * Negative(N): a última operação - mesmo se de movimentação de dados apenas - teve resultado negativo;
    * Zero(Z): a última operação - mesmo se de movimentação de dados apenas - teve resultado zero;
    * Carry(C): A última operação aritmética gerou carry

Como discutido com o professor, como as instruções do STM8 possuem muitos modos de endereçamento, a maior parte dos quais acessa memória RAM (que ainda não temos), e tem pouquíssimos registradores, a maior parte das instruções foi implementada parcialmente (sem o acesso a memória) ou com alterações (possibilitando usar os registradores t0 a t3, por exemplo). A pasta "instrucoes" contém prints do datasheet do processador-base, com setas vermelhas indicando grosso modo as formas de usar as instruções que foram implementadas.

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
  Soma um valor ao registrador acumulador A e armazena no acumulador. Pode somar valores imediatos, registradores ou memória.
## Formato Assembly
  * Soma com imediato: `ADD A,#$VALOR`, onde VALOR é um número com sinal de 10 bits
  * Soma com memória: `ADD A,$ENDEREÇO`, onde ENDEREÇO é um valor de até 10 bits selecionando um endereço de RAM (ainda não implementado)
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
  subtrai um valor do registrador acumulador A e armazena o resultado acumulador. Pode subtrair valores imediatos, registradores ou memória.
## Formato Assembly
  * Soma com imediato: `SUB A,#$VALOR`, onde VALOR é um número com sinal de 10 bits
  * Soma com memória: `SUB A,$ENDEREÇO`, onde ENDEREÇO é um valor de até 10 bits selecionando um endereço de RAM (ainda não implementado)
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
  Carrega o registrador A com  o valor do registrador X ou Y, um valor imediato, ou um endereço da RAM; ou o registrador X, o registrador Y, ou um endereço da RAM com o valor do registrador A.
## Formato Assembly
  * registrador para acumulador: `LD A,(FONTE)`, onde FONTE é X ou Y.
  * imediato para acumulador: `LD A,#VALOR`, onde VALOR é um número com sinal de 6 bits.
  * memória para acumulador: `LD A,$ENDEREÇO`, onde ENDEREÇO é um valor de até 6 bits selecionando um endereço de RAM.
  * memória por ponteiro para acumulador: `LD A, (REGISTRADOR)`, onde REGISTRADOR é X ou Y.
  * acumulador para registrador: `LD (DESTINO), A`, onde DESTINO é X ou Y.
  * acumulador para memória: `LD $ENDEREÇO, A`, onde ENDEREÇO é um valor de até 6 bits selecionando um endereço de RAM.
  * acumulador para memória por ponteiro: `LD A, (REGISTRADOR)`, onde REGISTRADOR é X ou Y.
## Formato de instrução
| opcode (14 a 12) |       SEL (11 a 10)                | POSICAO (9)                            | DADO (8 a 0)               |
|------------------|:----------------------------------:|----------------------------------------|----------------------------|
| `011`            | Seleciona tipo do segundo operador | `0` se A é a fonte, `1` se é o destino | De onde o valor é retirado |

onde:

| Descrição                                                  |  SEL | DADO                                        |
|------------------------------------------------------------|:----:|---------------------------------------------|
| Retira dado da instrução                                   | `00` | Número com sinal de 9 bits                  |
| Retira dado do endereço indicado                           | `01` | endereço de 9 bits                          |
| Retira dado do  registrador X                              | `10` |                  `0` se o registrador é usado como valor, `1` se como endereço                 |
| Retira dado do  registrador Y                              | `11` |                  `0` se o registrador é usado como valor, `1` se como endereço                 |

Obviamente, POSICAO = `0` e SEL = `00` não funciona.

## Flags afetadas:
Sendo R14-0 os bits escritos no destino:
  * N : `R14`
  * Z : `R = 0`
As flags C e V não são alteradas.

# MOV
## Descrição
  Carrega um endereço na RAM com o valor de outro endereço ou um valor imediato.
## Formato Assembly
  * imediato para memória: `MOV $DESTINO, #$FONTE`, onde `DESTINO` é um endereço e `FONTE` um valor imediato
  * Memória para memória: `MOV $DESTINO, $FONTE`, onde `DESTINO` e `FONTE` são endereços 
## Formato  de instrução:
| opcode (14 a 12) | DESTINO(11 a 6)    | SEL (5)                                                         | FONTE(4 a 0)                |
|------------------|--------------------|-----------------------------------------------------------------|-----------------------------|
| `100`            | Endereço de 6 bits | Seleciona se o valor será interpretado como endereço ou literal | Endereço ou valor de 5 bits |

## Flags afetadas:
Nenhuma.


# JRxx (Jump Relative) 
## Descrição
Pula somando o parâmetro ao valor do PC se uma condição verificada no registrador de estados é verdadeira.
## Formato Assembly:
`JRxx ADDR`, onde `xx` é o tipo de condição e `ADDR` é o offset para fazer o pulo relativo (substitui os bits menos significativos do program counter), ou uma label definida como `<nome da label>:` que indica a instrução imediatamente após o label.
## Formato de instrução:
| opcode (14 a 12) |   xx(11 a 8) |        ADDR(7 a 0)        |
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
| Verifica se o resultado era estritamente positivo                              | `0110` | JRPL      | `Z = 0 AND N = 0`                  |
| Verifica se o operando da esquerda era maior ou igual ao da direita, com sinal | `0111` | JRSGE     | `(N XOR V) = 0`                    |
| Verifica se o operando da esquerda era maior que o da direita, com sinal       | `1000` | JRSGT     | `Z OR (N XOR V)) = 0`              |
| Verifica se o operando da esquerda era menor ou igual ao da direita, com sinal | `1001` | JRSLE     | `(Z OR (N XOR V)) = 1`             |
| Verifica se o operando da esquerda era menor que o da direita, com sinal       | `1010` | JRSLT     | `(N XOR V) = 1 `                   |
| Verifica se o operando da esquerda era maior ou igual ao da direita, sem sinal | `0011` | JRUGE     | `C = 0`                            |
| Verifica se o operando da esquerda era maior que o da direita, sem sinal       | `1011` | JRUGT     | `C = 0 AND Z = 0`                  |
| Verifica se o operando da esquerda era menor ou igual ao da direita, sem sinal | `1100` | JRULE     | `C = 1 OR Z = 1`                   |
| Verifica se o operando da esquerda era menor que o da direita, sem sinal       | `0000` | JRULT     | `C = 1`                            |
| Verifica se houve overflow                                                     | `1101` | JRV       | `V = 1`                            |
| Verifica se o resultado é não-negativo                                         | `1110` | JRNMI     | `N = 0`                            |
| Nunca pula                                                                     | `1111` | JRF       |  false                             |

OBS: As operações de comparação (JREQ, JRNE, JRSGE, JRSGT, JRSLE, JRSLT, JRUGE, JRUGT, JRULE, JRULT) só mantém seu comportamento "semântico" se a última operação foi uma subtração entre os valores que se desejava comparar. A operação JRNMI não existe na arquitetura STM8, e foi implementada pois havia um índice sobrando, e a operação JRPL, nessa arquitetura, teria o comportamento da JRNMI.

## Flags afetadas
Nenhuma.

# JP (Jump Absolute)
## Descrição
"Pula" setando o PC para o label ou endereço passado.
## Formato Assembly:
`JP ADDR`, onde `ADDR` é o endereço de 11 bits para pular incondicionalmente (substitui os bits menos significativos do program counter), ou uma label definida como `<nome da label>:` que indica a instrução imediatamente após o label.
## Formato de instrução:
| opcode (14 a 12) |     ADDR(11 a 0)    |
|------------------|:-------------------:|
| `110`            | Endereço de 12 bits |

## Flags afetadas
Nenhuma.
