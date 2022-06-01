#1. Carrega R3 (o registrador 3) com o valor 0
r3 = 0
#2. Carrega R4 com 0
r4 = 0

#5. Se R3<30 salta para instrução do passo 3
while r3 < 30:
#3. Soma R3 com R4 e guarda em R4
  r4  += r3
#4. Soma 1 em R3
  r3 += 1

s#6. Copia valor de R4 para R5
r5 = r4
print(r4)
