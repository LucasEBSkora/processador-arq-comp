# Pesquisa Preliminar - STM8
Pesquisa sobre a estrutura de um processador da família STM8 baseado no manual disponível em https://www.st.com/content/ccc/resource/technical/document/programming_manual/43/24/13/9a/89/df/45/ed/CD00161709.pdf/files/CD00161709.pdf/jcr:content/translations/en.CD00161709.pdf

Tais processadores são projetados para ser baratos e eficientes, contando com 6 registradores internos acessáveis, 20 modos de endereçamento e 80 instruções.

# Estrutura e nome dos registradores
Os 6 registradores internos acessáveis incluem 2 registradores de 16 bits para ìndices, um Stack Pointer de 24 bits, e um registrador de flags de 8 bits. Os registradores de 16 bits permitem operações de endereçamento com ou sem offset e operações de leitura-modificação-escrita na memória. O registrador de flags fornece 7 flags diferentes sobre o resultado da última operação executada.

Os registradores são:
* A: acumulador de 8 bits, guarda operandos e o resultado de operações lógicas e aritméticas, além de manipulação de dados em geral;
* X e Y: registradores de índice de 16 bits, armazenam endereços ou resultados de manipulação de dados temporários;
* PC: Program Counter de 24 bits, o que permite ao processador acessar até 16Mbytes de memória;
* SP: Stack Pointer de 16 bits, contendo o endereço do próximo espaço livre na pilha, que guarda o contexto da CPU durante chamadas à subrotinas ou interrupções, ou usada diretamente pelo usuário através de instruções `POP` ou `PUSH`. É inicializado para o endereço máximo, e então decrementado quando dados são adicionados. Se passa do endereço mínimo, volta para o máximo, ocasionando perda de dados. Uma chamada a subrotina em geral ocupa 3 espaços de memória, enquanto interrupções empurram o conteúdo dos outros 5 registradores para a pilha, ocupando 9 bytes e 8 ciclos da CPU;
* CC: Registrador de Código de Condição de 8 bits, um registrador que armazena flags sobre o resultado da última instrução e o estado do processador, que podem ser acessadas e testadas sepradamente. As flags são:
    * V: Overflow: overflow ocorreu na última operação aritmética com sinal;
    * I1: Interrupt mask Level 1 - ver abaixo;
    * H: Half Carry bit - Carry entre os bits 3 e 4 da ULA durante adições de 8 bits (usado para rotinas com BCD), e entre os bits 7 e 8 para adições e subtrações de 16 bits 
    * I0: Interrupt mask Level 0 - ver abaixo;
    * N: Negative: Indica se o resultado da última operação aritmética, lógica ou de manipulação de dados foi negativa (MSB em `1`);
    * Z: Zero: Indica se o resultado da última operação aritmética, lógica ou de manipulação de dados foi 0;
    * C: Carry: Indica se houve carry na última operação (seja de 1 ou 2 bytes);
    Essas flags estão dispostas na ordem V,-,I1,H,I0,N,Z,C (o sétimo bit não é usado para nada)

O valor das Flags em I1 e I0 indica o nível da "interruptibilidade" atual do processador de acordo com sua atividade (ou seja, indicam a prioridade mínima que uma interrupção deve ter para ser tratada imediatamente), na seguinte ordem crescente de prioridade de acordo com (I1, I0): `10`, `01`, `00`, `11`.

Além disso, há o CFG_GCR (Global Configuration Register), que é usado para aplicações de baixo consumo. Ele contém apenas um bit, o AL: Activation Level. Em aplicações de baixíssimo consumo, o processador fica a maior parte do tempo parado (modo WFI/HALT) e é "acordado" através de interrupções para executar uma tarefa curta o suficiente para ser tratada apenas integralmente com a interrupção, sem ter que voltar ao programa principal. Nesses casos, se o bit AL estiver em 1, o retorno da interrupção (`IRET`) não irá restaurar o estado do processador que foi armazenado na pilha antes de voltar ao modo de WFI/HALT, o que só seria necessário se realmente houvesse uma função principal que seria executada, e econimizando os ciclos gastos para armazenar e restaurar o estado dos registradores com a pilha.

# Instruções originais do processador a implementar para operações de:
As instruções são "Orientadas à 8 bits" com comprimento médio de 2 bytes.
## Carga de constante;
A carga de constante é feita através da instrução de Load:  `LD dst, src`, em que dst é o destino e o src é a fonte, ambos podendo ser um byte de memória ou um registrador.
## Cópia de valor entre registradores;
É feita através da instrução de Move: `MOV dst, src`, em que a fonte (source) é o registrador com o valor a ser copiado, e o destino é o registrador para onde será copiado, as informações da fonte não são alteradas no processo.
## Soma de dois valores;
A soma de dois valores é feita através da istrução de um ADD: `ADD A, src`, em que A seria o registrador acumulador e o src seria a fonte a ser somada a ele. Vale lembrar que também existe a operação ADC (*Addition Carry*) através da sintaxe `ADC A, src`, onde pode ser feitas operações com mais de 8 bits (com Carry). É feito da mesma forma que o anterior porém tem um bit para a flag do Carry.
## Subtração de dois valores;
Muito semelhante a soma, é feita através da instrução: `SUB A, src`. O valor armazenado no acumulador A é subtraído pelo byte source, e o resultado é guardado no próprio A.
## Desvio incondicional
É feito através da instrução de Jump `JP dst`. Este jump basicamente substitui o valor de PC atual pelo valor do dst, que é um endereço no mesmo local de memória. O controle então passa para a instrução endereçado pelo PC. Quando cruza uma seção da memória, é necessário utilizar a instrulão Jump Section `JPF dst`, utilizado para quando o destino é um endereço estendido.
# Desvio condicional
Feito através da instrução Conditional Jump `JRxx dst`. Nessa instrução, se a condição é verdadeira, o PC é atualizado pela adição entre ele e o dst. Se não, o programa continua normalmente.

# Instruções de acesso à memória (modo de endereçamento indireto)
Os 18 (sim, no início do manual ele fala 20, mas na seção dedicada diz 18) modos de endereçamento, incluindo endereçamento indireto relativo e indexado, permitem rotinas com branches sofisticados ou funções com estilo switch-case, e é otimizado para implementar programas escritos em C eficientemente.

O manual agrupa esses modos de endereçamento em 8 grupos principais: Inerente, Imediato, direto, indexado, indexado pelo Stack Pointer, indireto, relativo, e operação de bit.

* O inerente corresponde a instruções que não precisam de parâmetros adicionais, e normalmente ocupam apenas 1 ou 2 bytes de memória.

* O imediato tem o operando ocupando o byte imediatamente após o operador, normalmente com 1 byte de instrução e um para o operando - Equivalente à `A = 10`.

* Para o endereçamento direto (acesso à um espaço de memória, com o endereço fornecido), as instruções tem 1 byte para a instrução e de 1 a 3 bytes para o endereço usado (embora nem toda instrução suporte usar os 3 tamanhos de endereço) - Equivalente à `A = *10`

* O modo indexado acessa o endereço no registrador X, Y ou SP (modo indexado pelo Stack Pointer) somando (se desejado) um offset de 1 a 3 bytes (embora nem toda instrução suporte usar os 3 registradores ou tamanhos de offset) - Equivalente à `A = *(X + 10)`

* O modo indireto acessa o endereço de memória indicado em outro endereço de memória. O endereço do ponteiro pode ter 1 ou dois bytes, e o ponteiro em si indica um endereço de 2 bytes - Equivalente à `A = *(X)`

* O modo indireto indexado acessa o endereço de memória indicado pela soma do valor de um registrador com o valor indicado por um ponteiro. O endereço do ponteiro do offset pode ter 1 ou dois 2, e o resultado em si indica um endereço de até 3 bytes - Equivalente à `A = *(X + *10)`.

* O modo relativo serve para modificar o Program Counter somando um offset (imediato) de 8 bits com sinal relativo ao início da próxima instrução, usado em jumps condicionais e relativos, além de chamadas relativas.

* O modo de operação de bit permite modificar um bit de memória diretamente. Aceita um endereço de 1 a 2 bytes e, dentro da instrução, especifica qual bit dentro daquele endereço será modificado (0 a 7). 

* Por fim, há o modo relativo de bit direto, que é usado nas instruções `BTJT`e `BTJF` (__Bit Test and Jump__ __True__ e __False__) que testa o valor de um bit indicado por um endereço de 2 bytes, e um seletor de bit, e se o bit for igual ao desejado, soma um offset de 8 bits com sinal ao PC. No manual, esse modo é considerado uma mistura do Relativo com o operação de bit, e portanto não aparece na lista de grupos acima.
