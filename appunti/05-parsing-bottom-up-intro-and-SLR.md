## Intro
Queste tipologi di parsing condividono le stesse tecniche fondamentali.
* La $P$ delle nostre grammatiche va sempre estesa a $P^\prime$ aggiungendo la produzione  $S^\prime \to S$ con $S^\prime$ un non-terminale *fresh*.
* Lo stesso algoritmo shift/reduce per il parsing.
* La costruzione di un automa caratteristico come controllore dell'algoritmo di parsing.
## Automi LR(0)
Iniziamo col dire che LR(0) signica le leggiamo la parola da sinistra a destra L, compiamo derivazioni rightmost R e non abbiamo simboli nel lookahead 0.
Gli automi LR(0) sono formati da stati, i quali sono insiemi di LR(0)-items: $A \to \alpha \cdot \beta$.
### LR(0)-items
Consideriamo l'item $S^\prime \to \cdot S$, vuol dire che dobbiamo ancora leggere la parola da parasare e la parola risulterà accettata se deriverà da $S$.
Possiamo affermare che il nostro item $S^\prime \to \cdot S$ dovrà essere nello stato iniziale chiamato $P_0$.
Anche altri item potrebbero essere in $P_0$.
### Chiusura di un insieme di LR(0)-items
#### Definizione
Sia $P$ un insieme di LR(0)-items, allora $closure_0(P)$ è il più piccolo insieme che soddisfa la seguente equazione:
$$closure_0(P) = P \cup \{ B \to \cdot \gamma | A \to \alpha \cdot B \beta \in closure_0(P) \land B \to \gamma \in P^\prime \}$$
In partica la chiusura aggiunge ad uno stato, per tutti gli item con il punto davanti ad un non-terminale, tutte le derivazioni di quei non-terminali.
#### Esempio
Prendiamo la grammatica:
$$\begin{cases} E^\prime \to E \\ E \to E+T | T \\ T \to T*F | F \\ F \to (E) | id\end{cases}$$
Come si può vedere abbiamo aggiunto il nuovo start symbol *fresh*.
Computiamo $closure_0(\{E^\prime \to \cdot E\})$ passo per passo:
1. Iniziamo con $closure_0(\{E^\prime \to \cdot E\}) = \{E^\prime \to \cdot E\}$
2. Abbiamo il marker davato al non-terminale $E$ quindi aggiungiamo le sue derivazioni
	1. Aggiungo $\{E \to \cdot E+T\} \cup \{E \to \cdot T\}$
3. Abbiamo il marker davanti al non-terminale $T$, possiamo ignorare $E$ avendolo già inserito.
	1. Aggiungo $\{ T \to \cdot T*F\} \cup \{ T \to \cdot F \}$
4. Abbiamo il marker davanti al non terminale $F$, come prima ignoro $T$.
	1. Aggiungo $\{ F \to \cdot (E) \} \cup \{ F \to \cdot id \}$
Concludiamo che quindi:
$$closure_0(\{ E^\prime \to \cdot E \}) = \{ \{E^\prime \to \cdot E\}, \{E \to \cdot E+T\}, \{E \to \cdot T\}, \{ T \to \cdot T*F\}, \{ T \to \cdot F \}, \{ F \to \cdot (E) \}, \{ F \to \cdot id \} \}$$
#### Algoritmo
````
function closure0(P)  
forach item ∈ P do
	item.unmarked=True;
while ∃item ∈ P : item.unmarked == True do  
	item.unmarked = False;  
	if item has the form A → α · Bβ then  
		foreach B → γ ∈ P′ do  
			if B → ·γ ∉ P then  
				add B → ·γ as an unmarked item to P ;  
return P ;
````
### Costruzione automa LR(0)
Dobbiamo costruire l'automa popolando un insieme di stati mentre definiamo la funzione di transizione. (non è così difficile come sembra, basta trovare esercizi facili in esame)
* **Inizio:** per prima cosa mettiamo nel kernel dello stato iniziale $P_0$ la produzione $S^\prime \to \cdot S$.
* **Ripetizione:** ripetiamo questo procediamento per ogni stato non ancora visitato:
	* Costruiamo $closure_0$(kernel), con kernel intendiamo il kernel di quello stato.
	* Ora gli item nella collezione avranno la forma $A \to \alpha \cdot Y \beta$, signica che nello stato attuale ho già letto $\alpha$ e posso compiere una $Y$-transizione.
	* Creiamo ora uno stato $P^\prime$ attraverso la transizione $A \to \alpha Y \cdot \beta$, che ne comporrà il kernel.
	  Se $Y$ è un terminale abbiamo compiuto un'operazione di shift.
E' possibile che il kernel del nostro stato $P^\prime$ sia il kernel di uno stato pre-esistente detto $Q$, allora la $Y$-produzione andrà in $Q$ e non dovremmo creare $P^\prime$.
#### Esempio
Costruire l'automa caratteristico per il parsing LR(0) per la seguente grammatica:
$$\begin{cases} S \to aABe \\ A \to Abc | b \\ B \to d \end{cases}$$
* Iniziamo con lo stato 0:
	* Kernel: {$S^\prime \to \cdot S$}
	* Corpo: {$S \to \cdot aABe$}
* $\tau(0,S)$ e definisco lo stato 1:
	* Kernel: {$S^\prime \to S \cdot$}
* $\tau(0,a)$ e definisco lo stato 2:
	* Kernel: {$S \to a \cdot ABe$}
	* Corpo: {$A \to \cdot Abc$, $A \to \cdot b$}
* $\tau(2,A)$ e definisco lo stato 3:
	* Kernel: {$S \to aA \cdot Be$, $A \to A \cdot bc$}
	* Corpo: {$B \to \cdot d$}
* $\tau(2,b)$ e definisco lo stato 4:
	* Kernel: {$A \to b \cdot$}
* $\tau(3,B)$ e definisco lo stato 5:
	* Kernel: {$S \to aAB \cdot e$}
* $\tau(3,b)$ e definisco lo stato 6:
	* Kernel: {$A \to Ab \cdot c$}
* $\tau(3,d)$ e definisco lo stato 7:
	* Kernel: {$B \to d \cdot$}
* $\tau(5,e)$ e definisco lo stato 8:
	* Kernel: {$S \to aAbe \cdot$}
* $\tau(6,c)$ e definisco lo stato 9:
	* Kernel: {$A \to Abc \cdot$}
Graficamente ottengo il seguente automa:

![automa-LR(0)-ex](./img/05/automa-LR(0)-ex.png)

#### Algoritmo
````
initialize the collection Q to contain P0 = closure0({S′ → ·S});  
p0.unmarked = True;  
while ∃ P ∈ Q : p.unmarked == True do  
	P.unmarked = False;  
	foreach Y a destra del marker in qualche item di P do  
		Tmp = kernel(P, Y-transione); //il kernel da P con una Y-transizione 
		if Q contien già uno stato R il cui kernel è Tmp then  
			Q = Y -target of P;  
		else  
			Q.add(closure0(Tmp)); //come stato unmarked  
			closure0(Tmp) = Y -target of P;
````
## Automi LR(1)
Piccolo inciso per introdurre un concetto che serve nelle tabelle di parsing.
Questi automi sono più "ricchi" di informazioni di un automa LR(0), gli stati sono composti da insiemi di items LR(1).
LR(1)-item: $[A \to \alpha \cdot \beta, \Delta]$ dove $L \subseteq T \cup \{\$\}$
## Costruzione tabella di parsing
Dobbiamo riepire una matrice $M$ nella quale le entry hammo la forma $M[P,Y]$ con $P$ uno stato e $Y$ un simbolo del vocabolario, la riempiremo con le seguenti regole:
* Se $Y$ è un terminale e $\tau(P,Y) = Q$ inseriasco la mossa `shift Q`.
* Se $P$ contiene una produzione del tipo $A \to \beta \cdot$
	* Nel caso LR(0)-item $[A \to \beta \cdot]$ allora inserisco `reduce` $A \to \beta$
	* Nel caso LR(1)-ite, $[A \to \beta \cdot, \Delta]$ inserisco la riduzione in base a cosa ho in $\Delta$ detto *Lookahead set*
* Se $P$ contiene l'accempting item e $Y = \$$ allora inserisco `accept`
* Se $Y$ è un terminale o $ e non vale nessuan delle precedenti inserisco `error`
* Se $Y$ è un non-terminale e $\tau(P,Y) = Q$ inserisco `goto Q`