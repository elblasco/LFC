Ripercorriamo un istante tutte le fasi di front-end che abbiamo visto fino ad ora:
* **Analisi lessicale:** riconosce i vari lessemi e restituire una stringa i token ovvero quegli elementi di cui ha bisogno l'analizzatore sintattico.
* **Anlisi sintattica:** tutto il parsing, quindi veere o meno se una serie di token appartiene o meno al linguaggio di nostra comeptenza.
* **Analisi semantica:** compie controlli statici sulla compatibilità tra operatori e operandi come la validità delle istruzioni di controllo e condizionali come `if` e `while`.
* **Generazione di codice intermedio:** che vedremmo ora
E' possibile implemenatre l'analisi semantica durante l'analisi sintattica, ma questa agglomerazione è possibile anche con la generazione di codice intermedio che può essere fatta durante il parsing.
# Codice intermedio
E' il passo intermedio tra il nostro codice ed il codice macchina, rende più leggibile il codice macchina avvicinandosi molto.
E.g. nasconde le specifiche come il movimento di valori tra registri e memoria.
## Rappresentazione intermedia
Abbiamo più di una possibilità per poter vedere il codice intermedio, ma 3 sono le maggiori:
1. **Struttura a grafo:** partendo dai *parse tree* possiamo avere delle strutture a grafi come gli *AST* oppure un grafo diretto aciclico *DAG*, solitamente i *DAG* risultano più succinti degli *AST*.
2. **Codice a 3 indirizzi:** impedisce direferenziare più di tre avlori per ogni singolo statement riduce di molto la complessità degli statement stessi, genera codice della forma `x = y op z`.
   Noi useremo questa alternativa.
3. **Altro linguaggio:** utilizzare un altro linguaggio di programmazione, questo approccio ci salva dal dover implemenatre da 0 un back-end per il compilatore.
   La scelta preferita da molti è `C` per il suo compilatore estremamente efficente.
## Codice a 3 indirzzi
E' la rappresentazione testuale di un *AST*, come al solito un esempio vale più di mille parole.
Prendiamo l'*abstract syntax tree* che rappresenta una semplice espressione aritmetica.
![AST-ex](./img/09/AST-ex.png)
L'espressione risulta essere `x = a + b * c`, con precedenza all'addizione.
Come possiamo però vedere stiamo usndo 4 riferimenti nello statement, dobbiamo quindi spezzarli:
````
t1 = a + b
t2 = t1 * c
x = t2
````
Abbiamo a disposizione una grande varietà di istruzioni:
* `a1 = a2 op a3`
* `a1 = op a2` 
* `a1 = a2`
* `a1 = a2[a3]`
* `a1[a2] = a3`
* `goto L`
* `if a goto L`
* .......
Però la rappresentazione in modo testuale a 3 indirzzi ci facilita molto la generazione e l'ottimizzazione del codice macchina, tuttavia non è una tecnica così utilizzata perchè è troppo *machine dependent*.
## Codice intermedio
Supponiamo di avere un espressione del tipo:
````
if ( x < 100 || x > 200 && x != y ) x=0;
````
Una sua prima trasfornmazione in codice intermedio potrebbe essere:
````
	IF x < 100 GOTO L2
	GOTO L3
L3: IF x > 200 GOTO L4
	GOTO L1
L4: IF x != y GOTO L2
	GOTO L1
L2: x = 0
L1:
````
Però questo codice può essere ottimizzato, ovvero possiamo notare che controllando la falsità di alcuni statement possiamo eliminare dei GOTO ridondanti.
````
	IF x < 100 GOTO L2
	IF x <= 200 GOTO L1
	IF x == y GOTO L1
L2: x = 0
L1:
````
### Traduzione guidata da sinstassi
Possiamo quindi tradurre un *AST* in una serie di istruzioni a 3 operatori, come?
Prendiamo in esame la seguente grammatica:
$$\begin{cases} S \to id = E \\ E \to E_1+E_2 \\ E \to -E_1 \\ E \to (E_1) \\ E \to id \end{cases}$$
l'obbiettivo è di produrre del codice a 3 indirizzi con l'utilizzo di attributi e funzioni ausiliri:
* `E.addr` indica la posizione in cui è memorizzato il valore di `E`
* `S.code` e `E.code` indicano il codice emesso da `S `e `E`
* `gen(str)` emette la strimga `str`
* `newtemp()` genera un nuovo nodo
* `⊳` questo simbolo indica la concatenazione tra frammenti di codice intermedio
Quindi possiamo arricchire la grammatica che sta sopra con:
````
S -> id = E  S.code = E .code ⊳ gen(table.get(id) '=' E .addr)  
E -> E1 + E2  E .addr = newtemp()  
			  E .code = E1.code ⊳ E2.code ⊳ gen(E .addr '=' E1.addr '+' E2.addr)
E -> -E1  E.addr = newtemp()
		  E.code = E1.code ⊳ gen(E.addr '=' '-' E1.addr)
E -> (E1)  E.addr = E1.addr
		   E.code = E1.code
E -> id  E.addr = table.get(id)
		 E.code = ''
````
## Statement di controllo di flusso
Osservando la generazione di codice intermedio per un blocco `if-then` ci accorgiamo che la sua struttura è:

![if-then-schema](./img/09/if-then-schema.png)

Dove l'etichetta `B.true` punta alla prima istruzione a eseguire se la condizione è vera mentre `B.false` punta alla prima istruzione dopo la chiusura del blocco `then`.
Per poter implementare questi salti ci servono degli attributi per poter fare dei salti, ovviamente questi attributi possono essere sia ereditati che sintetizzati:
* `S.next`, ereditato, indica la prima istruzione da eseguire terminato il blocco di codice `S`.
* `S.code`, sintetizzato, è la sequenza di codice intermedio che implemeneta lo stato `S` e termina con un salto a `S.next`.
* `B.true`, ereditato, indica l'inizio del codice che va eseguito se `B` è `true`.
* `B.false`, ereditato, indica l'inizio del codice da eseguire se `B` è `false`.
* `B.code`, ereditato, è la sequenza i codice intermedio che implementano la condizione `B` e fanno il salto alle label `B.true` oppure `B.false`.