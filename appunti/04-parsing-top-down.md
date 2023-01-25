## Parsing
Data una grammatica $\mathcal{G} = \{ V, T, S, P \}$ e una parola $w$, il parsing serve a verficare se $w \in L(\mathcal{G})$ e fornisce un albero di derivazione.
I due maggiori approcci al parsing sono:
* Top-down: costruiamo le derivazioni leftmost dalla radice alle foglie
* Bottom-up: costruiamo le derivazioni rightmost dalle foglie alla radice (questo è l'approccio  così detto *ganzo* dalla Quaglia)
## Top-down parsing
Esempio 1
Sia $w = cad$ e la grammatica
$$ \mathcal{G} : \begin{cases} S \to cAd \\ A \to ab|a \end{cases}$$
Ad occhio sembra molto semplice, ma per l'algoritmo non è semplice distinguere quale non terminare scegliere.
Dovremmo usare del *backtrack* per poter decidere il terminale, ma sappiamo bene che questo apprioccio fa schizzare i costi alle stelle.
## Predictive Top-down parsing
In questo caso non è necessario applicare *backtrack* poichè facciamo riferimento ad una classe di grammatiche dette **grammatiche LL(1)**, vengono chiamate così perchè per essere analizate:
* Leggiamo la parola in input da sinistra a destra.
* Eseguiamo solo produzioni leftmost.
* Guardiamo un solo simbolo (non-terminale).
Tali grammatiche posso essere parsate senza usare *backtrack* ed in modo completamente deterministico.

Prendiamo un """semplice""" esempio (Diostronzo se dice ancora semplice mi alzo e me ne vado).
$$\mathcal{G}:\begin{cases}E \to TE^\prime \\ E^\prime \to +TE^\prime|\varepsilon \\ T \to FT^\prime \\ T^\prime \to *FT^\prime|\varepsilon \\ F \to (E)|id \end{cases}$$
Per le grammatiche LL(1) possiamo creare una tabella di parsing per guidare le derivazioni leftmost.

|    | id | + | * | ( | ) | $ |
| --- | --- | --- | --- | --- | --- | ---|
| $E$ | $E \to TE^\prime$|  |  | $E \to TE^\prime$ |  |  |
| $E^\prime$ |  | $E^\prime \to +TE^\prime$ |  |  | $E^\prime \to \varepsilon$ | $E^\prime \to \varepsilon$ |
| $T$ | $T \to FT^\prime$ |  |  | $T \to FT^\prime$ |  |  | 
| $T^\prime$ |  | $T\prime \to \varepsilon$ | $T^\prime \to ∗FT^\prime$ |  | $T^\prime \to \varepsilon$ | $T^\prime \to \varepsilon$|  
| $F$ | $F \to id$ |  |  | $F \to (E)$ |  |  |

Quindi data una parola $w$ dobbiamo leggerla e, consumando l'input, fare la produzione nella casella \[$T,w[i]$\].
Se capitiamo in una casella che è vuota dobbiamo laniare un errore.
### Algoritmo
````
input: w;
output: derivazioni leftmost per w, altrimenti error();
Stack S = Stack();
S.push($);
S.push(A);       //Ipotizziamo che lo start symbol sia A
b = w$.firstSymbol();
X = S.top();
while X != $ do
	if X == b then
		S.pop();
		b = w$.nestSymbol();
	else if isTerminal(X) then
		error();
	else if M[X ,b] == error then
		error();
	else if M[X , b] = X → Y1 . . . Yk then
		output(X → Y1 . . . Yk );
		S.pop();
		push Yk ;
		. . . ;
		push Y1;
	X = S.top();
````

### Tabella di parsing
L'algoritmo per fare il parsing ha una complessità lineare con $O(|w|)$, ma si basa su una teblla, come costruiamo tale tabella?
La cella $M[A,b]$ è consultata quando devo espandere $A$ ed il prossimo carattere in input è $b$.
Questo signica che dobbiamo assegnare la cella $M[A,b] = A \to \alpha$ se :
* Se nel body della nosra produzione con 0 o più derivazioni riesco ad avere come primo carattere la $b$, ovvero $\alpha \implies^* b \beta$. (concetto di first)
* Oppure se $\alpha \implies^* \varepsilon$ ed è pèossibile avere $S \implies^* wA\gamma$ con $\gamma \implies^* b \beta$. (concetto di follow)
## $first(\alpha)$
### Definizione "normale"
Chiamiamo $first(\alpha)$ l'insieme dei terminali che sono situati all'inizio delle stringhe che derivano da $\alpha$.
Se $\alpha \implies^* \varepsilon$ allora $\varepsilon \in first(\alpha)$ è un non terminale che è *nullable* ovvero dopo alcuni passi di derivazione diventerà la parola vuota $\varepsilon$.
### Definizione ricorsiva
* **Casi base:**
	* $first(\varepsilon) = \{ \varepsilon \}$
	* $first(a) = \{a\}$
* **Passo ricorsivo:**
	* $first(A) = \bigcup_{A \to \alpha} first(\alpha)$
### Algoritmo
````
input: w;
output: l'insieme dei first di una stringa
Set first(Y1 . . . Yn) = ∅;  
j = 1;
n = strlen(w);
while j ≤ n do  
	first(Y1 . . . Yn).add(irst(Yj) \ {ε});
	if ε ∈ first(Yj) then
		j = j + 1;
	else
		break;
if j = n + 1 then
	first(Y1 . . . Yn).add(ε);
````
### Esempio
Data la grammatica $\mathcal{G}$ generare i $first$ di ogni non terminale.
$$\mathcal{G}:\begin{cases}E \to TE^\prime \\ E^\prime \to +TE^\prime|\varepsilon \\ T \to FT^\prime \\ T^\prime \to *FT^\prime|\varepsilon \\ F \to (E)|id \end{cases}$$
Facciamo qualche esempio:
* $first(E) \implies first(T) \implies first(F) \implies \{(,id\}$
* $first(E^\prime) \implies \{+, \varepsilon\}$

|  | first |
| ---| --- |
| $E$ | {$(, id$} |
| $E^\prime$ | {$+, \varepsilon$} |
| $T$ | {$id, ($} |
| $T^\prime$ | {$\varepsilon, *$} |
| $F$ | {$id, ($} |
## $follow(A)$
La funzione $follow$ accetta come unico argomento un non-terminale.
### Definizione
Con $Follow(A)$ indichiamo l'insieme dei terminali che possono seguire $A$ in qualche derivazione.
### Algoritmo
````
input: un terminale A;
output: void andiamo semplicemente a modificare dei set follo(A) che noi pensiamo avere scope globale;
follow(S) = {$};  
foreach A != S do  
	follow(A) = ∅;  
repeat  
	foreach B → αAβ do  
		if β != ε then  
			follow(A).add(first(β) \ {ε});
		if β == ε or ε ∈ first(β) then  
			follow(A).add(follow(B)); 
until saturation;
````
I due `if` meritano una spiegazione:
* `β != ε`, allora A deve essere sempre seguito da una parola non vuota per cui aggiungo i $first(\beta) \backslash \{\varepsilon\}$ ovvero solo i primi terminali che $\beta$ può generare.
* `β == ε or ε ∈ first(β)` quindi se ho la parola vuota oppure $\beta$ è *nullable* posso dire che ciò che segue $B$ seguirà anche $A$.
### Esempio
Data la grammatica $\mathcal{G}$ generare i $follow$ di ogni non terminale.
$$\mathcal{G}:\begin{cases}E \to TE^\prime \\ E^\prime \to +TE^\prime|\varepsilon \\ T \to FT^\prime \\ T^\prime \to *FT^\prime|\varepsilon \\ F \to (E)|id \end{cases}$$
Inizio in maniera "ricorsiva" dall'ultimo al primo terminale.
Iniziamo per punti:
1. Iniziamo con $follow(E) = \$$
2. Prendiamo la prima produzione $E \to TE^\prime$ con $B = E$, $\alpha = T$, $A = E^\prime$ e $\beta = \varepsilon$, allora:
	1. False
	2. $follow(E^\prime).add(follow(E))$
3. Prendiamo la prima produzione $E \to TE^\prime$ con $B = E$, $\alpha = \varepsilon$, $A = T$ e $\beta = E^\prime$, allora: 
	1. $follow(T).add(first(E^\prime) \backslash \{\varepsilon\})$
	2. $follow(T).add(follow(E))$
4. Prendiamo $E^\prime \to + T E^\prime$ con $B=E$, $\alpha = +T$, $A = E^\prime$ e $\beta = \varepsilon$, allora:
	1. False
	2. $follow(E^\prime).add(E^\prime)$ inutile
5. Prendiamo $E^\prime \to + T E^\prime$ con $B=E$, $\alpha = +$, $A = T$ e $\beta = E^\prime$, allora:
	1. $follow(T).add(first(E^\prime) \backslash \{\varepsilon\})$
	2. $follow(T).add(follow(E^\prime))$
6. Prendiamo $T \to FT^\prime$ con $B = T$, $\alpha = F$, $A = T^\prime$ e $\beta = \varepsilon$, allora:
	1. False
	2. $follow(T^\prime).add(follow(T))$
7. Prendiamo $T \to FT^\prime$ con $B = T$, $\alpha = \varepsilon$, $A = F$ e $\beta = T^\prime$, allora:
	1. $follow(F).add(first(T^\prime) \backslash \{\varepsilon\})$
	2. $follow(F).add(follow(T^\prime))$
8. Prendiamo $T^\prime \to *FT^\prime$ con $B = T^\prime$,$\alpha = *$, $A = F$ e $\beta = T^\prime$, allora:
	1. $follow(F).add(first(T^\prime) \backslash \{\varepsilon\})$
	2. $follow(F).add(follow(T^\prime))$
9. Prendiamo $T^\prime \to *FT^\prime$ con $B = T^\prime$, $\alpha = *F$, $A = T^\prime$ e $\beta = \varepsilon$, allora:
	1. False
	2. $follow(T^\prime).add(follow(T^\prime))$
10. Prendiamo $F \to (E)$ con $B = F$, $\alpha = ($, $A = E$, e $\beta = )$, allora:
	1. $follow(E).add(first(')') \backslash \{\varepsilon\})$
	2. False
|  | first | computazione | follow |
| ---| --- | --- | --- |
| $E$ | {$(, id$} |$, )| $\{\$,)\}$|
| $E^\prime$ | {$+, \varepsilon$} | follow(E)| $\{\$,)\}$ |
| $T$ | {$id, ($} | +, follow(E) | $\{+,\$,)\}$ |
| $T^\prime$ | {$\varepsilon, *$} | follow(T) | $\{+,\$,)\}$ |
| $F$ | {$id, ($} | \*, follow(T') | $\{*,+,\$,)\}$ |
## Costruzione della tabella di parsing
Ora abbiamo tutte le componenti per costruire una tabella di parsing.
### Algoritmo
````
input : Grammatica G = (V , T , S, P);
output : Tabella di parsing predittivo M;
foreach A → α ∈ P do
	foreach b ∈ (first(α)\{ε})
		M[A,b] = A → α;
	if ε ∈ first(α) then
		foreach x ∈ follow(A)
			M[A,x] = A → α;
set to error () all the empty entries;
````

Per ogni transizione $A \to \alpha$ devo:
1. Aggiungere alla casella $M[A,b]$ il valore $A \to \alpha$ per ogni terminale $b$ nei $first(\alpha) \backslash \{\varepsilon\}$.
2. Se $\varepsilon \in first(\alpha)$, quindi se è *nullable* allora:
	1. Aggiungo alla casella $M[A,x]$ il valore $A \to \alpha$ per ogni terminale nei $follow(A)$.
#### Osservazioni
* Posso finire con più valori in una stessa cella (entry multiple-defined), in questo caso non è una grammatica LL(1) perchè viene a mancare il determinismo.
* Usiamo due variabili distinte $b$ e $x$ perchè nei $follow$ posso avere $ mentre no nei $first$.
### Esempio
Data la grammatica $\mathcal{G}$ dire se è LL(1) o meno.
$$\mathcal{G}: \begin{cases} E \to E + T | T \\ T \to T * F | F \\ F \to ( E ) | id \end{cases}$$
Iniziamo a calcolare $first$ e $follow$.
$first(E) = first(T) = first(F) = \{id, )\}$
$follow(E) = \{+, )\}$
$follow(T) = \{+, ∗, )\}$
$follow(F) = \{+, ∗, )\}$
|  | + | * | ( | ) | id | $ |
| --- | --- | --- | --- | --- | --- | --- |
| E |  |  | $E \to E + T$, $E \to T$ |  | $E \to E + T$, $E \to T$ |  |
| T |  |  | $T \to T *F$, $T \to F$ |   | $T \to T * F$, $T \to F$ |  |
| F |  |  | $F \to ( E )$ |  | $F \to id$ |  |
In questo caso viene meno il determinismo per via delle *entry multiple-defined*, ce se saremmo potuti accorgere quando abbiamo calcolati i $first$ e fermarci subito.