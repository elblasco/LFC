## Symbol table
Questa è la sttruttura dati più importante durante la compilazione dopo il *syntax tree*.
Tipicamente è implementata attraverso un dizionario e risulta fondamentale quando entrano in gioco attributi ereditati perchè su di essa vengono effettuate le operazioni di:
* `insert`, inserimento di un nuovo elemento
* `lookup` ricerca di un elemento
* `delete` rimozione di un elemento
Visti i tipi di operazione da eseguire la struttura dati ottimale da usare risulta essere la `Hash table` perchè posso eseguire tutte le funzioni in tempo costante.
### Risoluzione collisioni
#### Open adressing
Ogni bucket ha abbastanza spazio per un singolo elemento, inseriamo l'item che collide nel bucket successivo.
Quindi il contenuto della table è limitato alla dimensione dell'array dei buckets.
Purtroppo questo metodo soffre di performance non sono il top.
#### Separate chaining
Ogni bucket contiene una lista lineare infatti ogni item che collide viene inserito come nuovo item nella lista del bucket.
### Funzione di Hash
L'obbiettivo è convertire una stringa di caratteri (cioè il nome dell'identificatore) in un intero compreso tra 0 e $size-1$ dove $size$ è la dimensione dell'array che contiene i bucket.
1. Convertiamo ogni carattere in un intero non negativo tipicamente con meccanismi built-in del linguaggio in cui è implementato il compilatore.
2. Applichiamo una funzione di Hash $h$ adeguata, non vogliamo che nomi simili come tmp1, tmp2 collidano, quindi scorriamo tutta stringa.
3. Una buona scelta di funzione è $h = (\sum_{i=1}^{n}{\phi^{n-1}c_i})\ mod\ size$.
4. Dove $c_i$ è il valore numeri del i-esimo carattere e $\phi$ è una potenza di 2 quindi la moltiplicazione può essere uno shift.
### Scope
