Todas instruções tem exatamente 15 bits. Temos 8 registradores:
  * Z: registrador carregado sempre com constante 0;
  * A: Acumulador, único capaz de operações de soma e subtração;
  * X e Y: Registradores de índice, acessam memória 
  * t0 a t3: Registradores de "uso geral"

Como discutido com o professor, como as instruções do STM8 possuem muitos modos de endereçamento, a maior parte dos quais acessa memória RAM (que ainda não temos), e tem pouquíssimos registradores, a maior parte das instruções foi implementada parcialmente (sem o acesso a memória) ou com alterações (possibilitando usar os registradores t0 a t3, por exemplo). A pasta "instrucoes" contém prints do datasheet do processador-base, com setas vermelhas indicando grosso modo as formas de usar as instruções que foram implementadas.

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
  * Soma com imediato: `ADD A,#$VALOR`, onde VALOR é um número com sinal de 9 bits
  * Soma com registrador: `ADD A,REGISTRADOR`, onde REGISTRADOR é o nome ou número de um dos registradores
  * Soma com memória: `ADD A,$ENDEREÇO`, onde ENDEREÇO é um valor de até 9 bits selecionando um endereço de RAM (ainda não implementado)
  * Soma indireta: `ADD A,(REGISTRADOR)`, onde REGISTRADOR é X ou Y ou seus números associados, sendo usado como ponteiro
## Formato de instrução
| opcode (14 a 11) |   SEL (10 a 9)  | DADO                   |
|------------------|:---------------:|------------------------|
| `0001`           | Seleciona fonte | De onde retirar o dado |

onde:

| Descrição                                                  |  SEL | DADO                                        |
|------------------------------------------------------------|:----:|---------------------------------------------|
| Retira dado da instrução                                   | `00` | Número com sinal de 9 bits                  |
| Retira dado do registrador indicado                        | `01` | valor de 3 bits selecionando um registrador |
| Retira dado do endereço indicado (não implementado)        | `10` | Endereço de 9 bits indicando posição na RAM |
| Retira dado do local apontado por um registrador de índice | `11` | '0' para o registrador X, '1' para o Y      |

# SUB
## Descrição
  subtrai um valor do registrador acumulador A e armazena o resultado acumulador. Pode subtrair valores imediatos, registradores ou memória.
## Formato Assembly
  * Subtração com imediato: `SUB A,#$VALOR`, onde VALOR é um número com sinal de 9 bits
  * Subtração com registrador: `SUB A,REGISTRADOR`, onde REGISTRADOR é o nome ou número do registrador.
  * Subtração com memória: `SUB A,$ENDEREÇO`, onde ENDEREÇO é um valor de até 9 bits selecionando um endereço de RAM (ainda não implementado)
  * Subtração indireta: `SUB A,(REGISTRADOR)`, onde REGISTRADOR é X ou Y ou seus números associados, sendo usado como ponteiro
## Formato de instrução
| opcode (14 a 11) |   SEL (10 a 9)  | DADO                   |
|------------------|:---------------:|------------------------|
| `0010`           | Seleciona fonte | De onde retirar o dado |

onde

| Descrição                                                  |  SEL | DADO                                        |
|------------------------------------------------------------|:----:|---------------------------------------------|
| Retira dado da instrução                                   | `00` | Número com sinal de 9 bits                  |
| Retira dado do registrador indicado                        | `01` | valor de 3 bits selecionando um registrador |
| Retira dado do endereço indicado (não implementado)        | `10` | Endereço de 9 bits indicando posição na RAM |
| Retira dado do local apontado por um registrador de índice | `11` | '0' para o registrador X, '1' para o Y      |

# LD
## Descrição
  Carrega um registrador com o valor de outro registrador, um valor imediato ou da memória.
## Formato Assembly
  * Registrador para registrador: `LD (DESTINO),(FONTE)`, onde DESTINO e FONTE são nomes ou números de registradores.
  * imediato para registrador: `LD (DESTINO),#VALOR`, onde VALOR é um número com sinal de 6 bits
  * memória para registrador: `LD (DESTINO),$ENDEREÇO`, onde ENDEREÇO é um valor de até 6 bits selecionando um endereço de RAM (ainda não implementado).
  * memória por ponteiro para registrador: `LD (DESTINO),(REGISTRADOR)`, onde REGISTRADOR é X ou Y ou seus números associados, sendo usado como ponteiro
## Formato de instrução
| opcode (14 a 11) |       SEL (10 a 9)      | DESTINO (8 a 6)                                | FONTE (5 a 0)              |
|------------------|:-----------------------:|------------------------------------------------|----------------------------|
| `0011`           | Seleciona tipo da fonte | Número de 3 bits identificando um registrador  | De onde o valor é retirado |

onde

| Descrição                                                  |  SEL | FONTE                                       |
|------------------------------------------------------------|:----:|---------------------------------------------|
| Retira dado da instrução                                   | `00` | Número com sinal de 9 bits                  |
| Retira dado do registrador indicado                        | `01` | valor de 3 bits selecionando um registrador |
| Retira dado do endereço indicado (não implementado)        | `10` | Endereço de 9 bits indicando posição na RAM |
| Retira dado do local apontado por um registrador de índice | `11` | '0' para o registrador X, '1' para o Y      |



# JP (Jump Absolute) 
## formato Assembly:
`JP ADDR`, onde `ADDR` é o endereço de 11 bits para pular incondicionalmente (substitui os bits menos significativos do program counter), ou uma label definida como `label ADDR` que indica a instrução imediatamente após o label.
## formato de instrução:
| opcode (14 a 11) |     ADDR(10 a 0)    |
|------------------|:-------------------:|
| `1111`           | Endereço de 11 bits |