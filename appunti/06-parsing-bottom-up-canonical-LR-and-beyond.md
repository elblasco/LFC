## Automi LR(1)
Sono gli automi che riescono a parsare più grammatiche, ma per questo presentano un elevato numero di stati e un'elevata difficoltà computazionale.
### LR(1)-items
Gli items hanno la forma $[A \to \beta, \ \Delta]$, con $\Delta$ che viene detto *lookahead set*.
La chiusura di un item è chiamata $closure_1$ ed è più raffinata della $closure_0$, infatti dato l'item $\{[A \to \alpha \cdot B \beta, \ \Delta]\}$ la chiusura propaga i simboli seguenti $B$ a tutti gli item aggiunti all'insieme per chiudere $B$.
### $closure_1$ per LR(1)-items
Usiamo questa funzione più raffinata perchè ci permette, oltre che definire un set di partenza, anche di aggiungere elementi.
Questi set "più ampi" ci possono aiutare nel sapere quali caratteri dobbiamo aspettare di vedere per poter fare una `reduce`.
#### Definizione
Sia $P$ un insieme di LR(1)-items, allora $closure_1(P)$ è identifica il più piccolo insieme di item con il più piccolo *lookahead set* che soddisfa la seguente equazione:
$$closure_1(P) = P \cup \{ [B \to \cdot \gamma, \ \Gamma] : [A \to \alpha \cdot B \beta, \ \Delta] \in closure_1(P) \land B \to \gamma \in P^\prime \land first(\beta \Delta) \subseteq \Gamma\}$$
Dove $first(\beta \Delta) = \bigcup_{d \in \Delta} first(\beta d)$ e $P^\prime$ è l'insieme delle produzioni con l'aggiunta del nuovo start symbol $S^\prime \to S$.
Ora dopo ver tirato il calendario ci sarà passata la paura e potremmo vedere che l'equazione è risolvibile tramite il teorema del punto fisso.
#### Algoritmo
Con quel formulone pure la dovente si è spaventata quindi vediamola con un linguaggio più familiare a noi, lo pseudocodice:
````
function closure1(P)
	foreach item ∈ P do
		item.unmarked = True;
	while ∃ item ∈ P: item.unmarked==True do
		item.unmarked = False;
		if item has the form [A → α · Bβ, ∆] then
			Set ∆1 = Set();
			foreach d∈∆ do
				∆1.insert(first(βd));
			foreach B → γ ∈ P′ do
				if B → ·γ ∉ presenti_in(P) then
					Item nuovo = Item([B → ·γ, ∆1]);
					nuovo.unmarked = True;
					P.add(nuovo);
				else
					if ([B → ·γ, Γ] ∈ P and ∆1 ⊄ Γ) then
					update [B → ·γ, Γ] to [B → ·γ, Γ ∪ ∆1] in P;
					P.get([B → ·γ, Γ ∪ ∆1]).unmarked = True;
	return P ;
````
Sembra ancora uno schifo ma un esempio vale più di mille parole.
#### Esempio
Prendiamo la grammatica:
$$\mathcal{G} : \begin{cases} S \to aAd | bBd | aBe | bAe \\ A \to c \\ B \to c \end{cases}$$
Calcoliamo $closure_1(\{[S^\prime \to \cdot S, \ \{\$\}]\})$.
Detta a livello brutale dobbiamo "ricalcolare" ogni volta il follow di una produzione in base al contesto un cui ci troviamo.
$$0 : \begin{bmatrix} S^\prime \to \cdot S, \ \{\$\} \\ \hline S \to \cdot aAd, \ \{\$\} \\ S \to \cdot bBd, \ \{\$\} \\ S \to \cdot aBe,\  \{\$\} \\ S \to \cdot bAe, \ \{\$\}\end{bmatrix}$$
	Ora passiamo agli alrti stati, lo stato 1 è il classico di `accept` quindi lo saltiamo.
$$\tau(0,a) = 2 : \begin{bmatrix} S \to a \cdot Ad, \ \{\$\} \\ S \to a \cdot Be, \ \{\$\} \\ \hline A \to \cdot c, \ \{d\} \\ B \to \cdot c, \ \{e\} \end{bmatrix}$$
Come possiamo vedere abbiamo dovuto ricalcolare i $follow$ di $A$ e $B$.
Lasciatemi dire Ебать sti cazzo di LR(1)-items.
### Costruzione automa LR(1)
L'idea è di popolare gli stati mentre definiamo le funzioni di transizione.
Se lo stato $P$ contiene uno item della forma $[A \to \alpha \cdot Y \beta, \ \Delta]$, allora esiste uno stato $Q = \tau(P,Y)$ tale che conterrà l'item $[A \to \alpha Y \cdot \beta, \ \Delta]$ e tutti gli item di $closure_1(\{[A \to \alpha Y \cdot \beta, \ \Delta]\})$.
#### Algoritmo
````
initialize the collection Q to contain P0 = closure1({[S′ → ·S, {$}]});
P0.unmarked = True;
while ∃ P ∈ Q : P.unmarked == True do
	P.unmarked = False;
	foreach Y a destra del marker in un qualsiasi item di P do  
		Tmp = τ(P,Y).kernel();
		if ∃ R ∈ Q : R.kernel() == Tmp then
			τ(P,Y) = R;
		else
			State nuovo_stato = (closure1(Tmp));
			nuovo_stato.unmarked = True;
			Q.add(nuovo_stato);
			τ(P,Y) = nuovo_stato;
````
#### Esempio
Prendiamo la grammatica:
$$\mathcal{G} : \begin{cases} S \to aAd | bBd | aBe | bAe \\ A \to c \\ B \to c \end{cases}$$
Se proviamo a fare il parsing SLR(1) questa cosa non viene ma se proviamo a fare quello LR(1)......
Iniziamo con la costruzione degli stati (spero vi piaccia come ho organizzato la scrittura degli stati).
$$0 : \begin{bmatrix} S^\prime \to \cdot S, \ \{\$\} \\ \hline S \to \cdot aAd, \ \{\$\} \\ S \to \cdot bBd, \ \{\$\} \\ S \to \cdot aBe,\  \{\$\} \\ S \to \cdot bAe, \ \{\$\}\end{bmatrix}$$
$$ \tau(0,S) = 1 : \begin{bmatrix} S^\prime \to S \cdot, \ \{\$\} \end{bmatrix}$$
$$$\tau(0,a) = 2 : \begin{bmatrix} S \to a \cdot Ad, \ \{\$\} \\ S \to a \cdot Be, \ \{\$\} \\ \hline A \to \cdot c, \ \{d\} \\ B \to \cdot c, \ \{e\} \end{bmatrix}$$
$$\tau(0,b) = 3 : \begin{bmatrix} S \to b \cdot Bd, \ \{\$\} \\ S \to b \cdot Ae,\ \{\$\} \\ \hline B \to \cdot c, \ \{d\} \\ A \to \cdot c, \ \{e\} \end{bmatrix}$$
$$\tau(2,A) = 4 : \begin{bmatrix} S \to aA \cdot d, \ \{\$\} \end{bmatrix}$$
$$$\tau(2,B) = 5 : \begin{bmatrix} S \to aB \cdot e, \ \{\$\} \end{bmatrix}$$
$$\tau(2,c) = 6 : \begin{bmatrix} A \to c \cdot, \ \{d\} \\ B \to c \cdot,\ \{e\} \end{bmatrix}$$
$$\tau(3,B) = 7 : \begin{bmatrix} S \to bB \cdot d, \ \{\$\} \end{bmatrix}$$
$$\tau(3,A) = 8 : \begin{bmatrix} S \to bA \cdot e, \ \{\$\} \end{bmatrix}$$
$$\tau(3,c) = 9 : \begin{bmatrix} B \to c \cdot, \ \{d\} \\ A \to c \cdot,\ \{e\} \end{bmatrix}$$
$$\tau(4,d) = 10 : \begin{bmatrix} S \to aAd \cdot, \ \{\$\} \end{bmatrix}$$
$$\tau(5,e) = 11 : \begin{bmatrix} S \to aBe \cdot, \ \{\$\} \end{bmatrix}$$
$$\tau(7,d) = 11 : \begin{bmatrix} S \to bBd \cdot, \ \{\$\} \end{bmatrix}$$
$$\tau(8,e) = 11 : \begin{bmatrix} S \to bAe \cdot, \ \{\$\} \end{bmatrix}$$
Ora l'automa carrteristico dovrebbe essere questo oppure un grafo isomorfo a questo.

![LR(1)-ex](./img/06/LR(1)-ex.png)

La tabella è troppo lunga, non la riporto, ciomunque non ci sono conflitti ma il numero di stati è drasticamente aumentato.
## Caso studio LR(1)
Proviamo ora a fare il parsing LR(1) della seguente grammatica.
$$\mathcal{G} : \begin{cases} S \to L=R | R \\ L \to *R | id \\ R \to L \end{cases}$$
per mia semplicità di difitazione ometterò le parentesi grafe nei *lookahead set*, l'operatore \ indica concatena due elementi quindi $= / \$$ significa $\{=,\$\}$.
$$0 : \begin{bmatrix}S' \to \cdot S, \$ \\ \hline S \to \cdot L = R, \$ \\ S \to \cdot R, \$ \\ L \to \cdot * R, =/ \$ \\ L \to .id, = / \$ \\ R \to \cdot L, \$ \end{bmatrix}$$
$$\tau(0,S) = 1 : [ S^\prime \to S \cdot, \ \$ ]$$
$$\tau(0,L) = 2 : \begin{bmatrix}S \to L \cdot = R, \$ \\ R \to L \cdot, \$ \end{bmatrix}$$
$$\tau(0,R) = 3 : [ S \to R \cdot, \$ ]$$
$$\tau(0,*) = 4 : \begin{bmatrix} L \to * \cdot R, =/ \$ \\ \hline R \to \cdot L, =/ \$ \\ L \to \cdot *R, =/ \$ \\ L \to \cdot id, =/ \$ \end{bmatrix}$$
$$\tau(0,id) = 5 : [ L \to id \cdot, \ =/ \$ ]$$
$$\tau(2,=) = 6 : \begin{bmatrix} S \to L = \cdot R, \$ \\ \hline R \to \cdot L, \$ \\ L \to \cdot *R, \$ \\ L \to \cdot id, \$ \end{bmatrix}$$
$$\tau(4,R) = 7 : [ L \to *R \cdot , =/ \$ ]$$
$$\tau(4,L) = 8 : [R \to L \cdot, =/ \$ ]$$
$$\tau(4,*) = 4$$
$$\tau(4,id) = 5$$
$$\tau(6,R) = 9 : [ S \to L = R \cdot, \$ ]$$
$$\tau(6,L) = 10 : [ R \to L \cdot , \$ ]$$
$$\tau(6,*) = 11 : \begin{bmatrix} L \to * \cdot R, \$ \\ \hline R \to \cdot L, \$ \\ L \to \cdot *R, \$ \\ L \to \cdot id, \$ \end{bmatrix}$$
$$\tau(6,id) = 12 : [ L \to id \cdot, \$ ]$$
$$\tau(11, R) = 13 : [ L \to *R \cdot, \$ ]$$
$$\tau(11,L) = 10$$
$$\tau(11,*) = 11$$
$$\tau(11,id) = 12$$
