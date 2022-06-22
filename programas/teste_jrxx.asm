//JRxx
//JRC (Carry)
LD A, #$0
CP A, #$50
JRC #$2 //não deveria pular
CP A, #$16384
JRC #$2 //deveria pular
NOP

//JREQ (Equal)
LD A, #$50
CP A, #$49
JREQ #$2 //não deveria pular
CP A, #$50
JREQ #$2 //deveria pular
NOP

//JRMI (Minus/Negativo)
LD A, #$0
CP A, #$-1
JRMI #$2 //não deveria pular
CP A, #$1
JRMI #$2 //deveria pular
NOP

//JRNC (Not Carry)
LD A, #$0
CP A, #$16384
JRNC #$2 //não deveria pular
CP A, #$50
JRNC #$2 //deveria pular
NOP

//JRNE (Not Equal)
LD A, #$-50
CP A, #$-50
JRNEQ #$2 //não deveria pular
CP A, #$-49
JRNEQ #$2 //deveria pular
NOP

//JRNV (not Overflow)
LD A, #$16384
CP A, #$16384
JRNV #$2 //não deveria pular
CP A, #$0
JRNV #$2 //deveria pular
NOP

//JRPL (não negativo)
LD A, #$-37
JRPL #$2 //não deveria pular
LD A, #$25
JRPL #$2 //deveria pular

//JRSGE (Greater or Equal)
LD A, #$5
CP A, #$2
JRSGE #$2 //não deveria pular
CP A, #$5
JRSGE #$2 //deveria pular
NOP
CP A, #$6
JRSGE #$2 //deveria pular
NOP

//JRSGT (Greater than)
LD A, #$-5
CP A, #$-4
JRSGT #$2 //não deveria pular
CP A, #$-5
JRSGT #$2 //não deveria pular
CP A, #$-3
JRSGT #$2 //deveria pular
NOP

//JRSLE (Less or Equal)
LD A, #$0
CP A, #$50
JRSLE #$2 //não deveria pular
CP A, #$0
JRSLE #$0 //deveria pular
NOP
CP A, #$-7
JRSLE #$2 //deveria pular
NOP

//JRSLT (Less than)
LD A, #$5
CP A, #$6
JRSLT #$2 //não deveria pular
CP A, #$5
JRSLT #$2 //não deveria pular
CP A, #$-10
JRSLT #$2 //deveria pular
NOP


//TERMINAR
//JRUGE (Unsigned Greater or Equal)
LD A, #$5
CP A, #$2
JRUGE #$2 //não deveria pular
CP A, #$5
JRUGE #$2 //deveria pular
NOP
CP A, #$6
JRUGE #$2 //deveria pular
NOP

//JRUGT (Unsigned Greater than)
LD A, #$-5
CP A, #$-4
JRUGT #$2 //não deveria pular
CP A, #$-5
JRUGT #$2 //não deveria pular
CP A, #$-3
JRUGT #$2 //deveria pular
NOP

//JRULE (Unsigned Less or Equal)
LD A, #$0
CP A, #$50
JRULE #$2 //não deveria pular
CP A, #$0
JRULE #$0 //deveria pular
NOP
CP A, #$-7
JRULE #$2 //deveria pular
NOP

//JRSLT (Unsigned Less than)
LD A, #$5
CP A, #$6
JRSLT #$2 //não deveria pular
CP A, #$5
JRSLT #$2 //não deveria pular
CP A, #$-10
JRSLT #$2 //deveria pular
NOP

//JRV (Overflow)
LD A, #$16384
CP A, #$0
JRV #$2 //não deveria pular
CP A, #$16384
JRV #$2 //deveria pular
NOP

//JRT (True)
JRT #$2
NOP

//JRF (False)
JRF #$-10
