Calcoliamo informazioni aggiuntive una volta che la struttura sintatica è conosciuta, queste informazioni sono al di là delle capacità delle grammatiche *context-free*, diciamo "vanilla".
Tipicamente in questa fase:
* Popoliamo la tabella dei simboli (*symbol table*) dopo ogni dichiarazione.
* Facciamo dell'inferenza sui tipi e dei controlli su di essi nelle espressisoni e dichiarazioni.
Questo tipo di analisi si divide in due categorie:
* Analisi richiesta per stabilire la correttezza
* Analisi per aumentare l'efficenza del programma tradotto.
Il modo più semplice per implementare l'analisi semantica è identificare proprietà (attributi) di un simbolo della grammatica, e scrivere delle regole (regole semantiche) per descrivere come calcolare proprietà legate alle produzioni della grammatica.
L'insieme dato da (attributi, regole, ecc....) viene detto grammatica attribuita o *syntax-directed definition*.
Come struttura la scelta ottimale ricade su un *abstract syntax tree* che risulta essere una rappresentazione compressa di un *derivation tree*.
## Syntax-Directed Definitions
Introduciamo ora meglio il concetto di grammatica attribuita (Syntax-Directed Definitions) per gli amici *SDD*.
Sono delle grammatiche *context-free* arricchite con attributi e regole:
* **Attributi:** associti con dei simboli della grammatica, possono essere tipi, numeri, riferimenti alla tabella dei simboli ecc....
* **Regole semantiche:** associate con ogni produzione, tipicamente regolano il calcolo di attributi in funzione di attributi degli altri simboli della produzione.
Sia i simboli che le regole sono usati per dare senso (con l'analisi semantica) a quello che è espresso come un flusso di token.
## Tipi di attributi
Gli attributi dei non-terminali sono suddivisi in due categorie:
* **Sintetizzati:** gli attributi del driver sono definiti come una funzione degli attributi dei simboli della produzione.
* **Ereditati:** gli attributi dei non-terminali nel body sono definiti come funzione degli attributi dei simboli della produzione. 
Gli attributi dei terminali posso essere solo sintetizzati poichè forniti dall'analizzatore lessicale e non esiste regola per calcolarli.
### Esempio
Prendiamo la nostra grammatica per le espressioni aritmetiche e proviamo a scrivere delle regole e degli attributi per essa.
$$\mathcal{G} : \begin{cases} S \to E \\ E \to E+T | T \\ T \to T*F | F \\ F \to (E) | digit \end{cases}$$
Consideriamo ora il *parse tree* SLR(1), e diciamo che se un *digit* ha valore 3 e l'altro 4 il risultato deve essere 7.

![parese-tree-ex](./img/07/parse-tree-ex.png)

Vediamo quindi che forma deve avere il suo *SDD* per poter computare il valore finale in $S$.
$$S \to E \hspace{2em} \{S.val = E.val\}$$
$$E \to E_1 + T \hspace{2em} \{E.val = E_1.val + T.val\}$$
$$E \to T \hspace{2em} \{E.val = T.val\}$$
$$T \to T_1 ∗ F \hspace{2em} \{T.val = T_1.val * F.val\}$$
$$T \to F \hspace{2em} \{T.val = F.val\}$$
$$F \to (E) \hspace{2em} \{F .val = E .val\}$$
$$F \to digit \hspace{2em} \{F.val = digit.lexval\}$$
Ora le regole sembrano abbastanza semplici e non necessitano di ulteriori spiegazioni tranne per un paio di appunti:
* La prima produzione $S \to E$ è una produzione aggiuntiva non necessria alla grammatica in se.
* Usiamo i numeri a pedice per differenziare lo stesso non-terminale nella stessa produzione.
* $digit.lexval$ è il valore che viene trovato nella tabella dei simboli.
L'*abstract syntax tree* risulta quindi in:

![abstract-syntax-tree](./img/07/parse-tree-ex-pt2.png)

## Valutazione in ordine di un SDD
Non è sempre possibile che un SDD possa essere valutato, quindi definiamo un grafo (orientato) delle dipendenze per il nostro SDD e verifichiamo che non ci siano conflitti.
* Impostare un nodo del grafo delle dipendenze per ogni attributo associato con ogni nodo del *parse tree*.
* Per ogni attributo $X.x$ usato per definire l'attributo $Y.y$ creiamo un arco dal nodo di $X.x$ al nodo di $Y.y$.
Una volta creato il grafo delle dipendenze dobbiamo trovare un ordinamento topologico per il grafo, se l'ordinamento non esiste allora l'*SDD* non è valutabile.
Se invece un ordinamento esiste allora possiamo valutare l'*SDD* e abbiamo trovato anche un ordine in cui farlo.
Quando un *SDD* ha sia attributi ereditati che sintetizzati non ci sono garanzie che esista un ordinamento topologico, infatti potrebbe esserci un ciclo all'interno del grafo quindi nessun sorting è possibile.
$$A \to B \hspace{2em} \{ A.s = B.i; \hspace{0.5em} B.i=A.s+7 \}$$
In questo caso l'attributo sintetizzato di $A$ ha bisogno dell'attributo ereditato di $B$ e viceversa.
Esistono due classi di *SDD* per le quali è garantita l'esistenza di un ordinamento topologico.
1. **S-attributed SDDs:** ci sono solo attributi sintetizzati quindi ci basta fare una visita in post-ordine.
2. **L-attributed SDDs:** attributi sia sintetizzati sia ereditati tali che:
	* Per ogni produzione $A \to X_1 \cdots X_n$ la definizione di ogni $X_j.i$ usa al più:
		* Attributi ereditati da $A$ oppure
		* Attributi ereditati o sintetizzati dai fratelli a sinistra, ovvero $X_1, \dots, X_{j-1}$
Gli *SDD* S-attribuiti sono ideali per il parsing bottom-up perchè l'albero può essere valutato mentre si fa il parsing.
Gli L-attribuiti sono convenienti con il paring top-down perchè ho attributi ereditato solo da sinistra e nel parsing top-down faccio derivazioni leftmost quindi ez.
### Esempio
Prendiamo la grammatica LL(1) per le operazioni aritmetiche:
$$\begin{cases} V \to E \\ E \to TE^\prime \\ E^\prime \to +TE\prime|\varepsilon \\ T \to FT^\prime \\ T^\prime \to *FT^\prime|\varepsilon \\ F \to (E)|digit \end{cases}$$
Facciamo il parsing di $3*5$, come si vede partiamo da $V \implies E \implies TE^\prime$, ora la Quaglia ha disegnato solo il sottoalbero che ha come radice $T$ visto che dobbiamo $E^\prime \implies \varepsilon$.
Essendo un parsing top-down utilizziamo un albero L-attribuito:

![LL(1)-parsing-tree](./img/07/LR(1)-parsing-tree.png)

Ogni .s sta per attributi sintetizzato mentre ogni .i sta per ereditato.
Iniziamo quindi con il dare le regole alle varie produzioni:
* Prima di tutto possiamo notare che quando $T^\prime$ vieme copiato in $T$ si ha già il valore della moltiplicazione.
  $$T \to FT^\prime \hspace{2em} \{T^\prime .i = F.s; \hspace{0.5em} T.s = T^\prime .s \}$$
  Quindi passiamo $T^\prime$ come valore ereditato $F.s$ e assegniamo a $T$ sintetizzato il valore di $T^\prime .s$.
  ![LR(1)-ex-pt2](./img/07/LR(1)-parsing-tree-pt2.png)
  
* Ora concentriamoci nelle produzioni di $T^\prime$, nel nostro caso abbiamo una moltiplicazione, quindi sappiamo che in $T^\prime .i$ è memorizato il valore del membro di sinistra per cui assegniamo a $T^\prime_1.i$ il valore della moltiplicazione.
  Dopodichè per poter risalire l'albero fino alla radice assegniamo a $T^\prime .s$ il valore del risultato finale del ramo destro che sarà memorizzato in $T^\prime_1 .s$.
  $$T^\prime \to *FT^\prime_1 \hspace{2em} \{ T^\prime_1 .i = F.s * T^\prime .i; \hspace{0.5em} T^\prime .s = T^\prime_1 .s \}$$
  ![LR(1)-ex-pt3](./img/07/LR(1)-parsing-tree-pt3.png)
## Valutazione durante il parsing bottom-up
Il nostro obbiettivo è implementare la traduzione della parola durante il processo di parsing anzichè ottere il parsing tree poi annotarlo poi valutarlo.
Il caso più semplice in cui questa elaborazione può essere fatta è durante l'algoritmo shift/reduce con un *SDD* S-attribuito.
L'idea è quella di tenere oltre ai due stack per gli stati *stSt* e per i simboli *symSt* un ulteriore stack per gli attributi *semSt*.
