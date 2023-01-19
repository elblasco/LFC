## Unione
### Lemma
La classe dei linguaggi liberi è chiusa rispetto all'unione insiemistica $\cup$, quindi se $L_1$ e $L_2$ sono due linguaggi liberi allora $L_1 \cup L_2$ è in linguagio libero.
### Dimostrazione
Pongo $L_1$ e $L_2$ due linguaggi liberie le loro grammatiche $G_1=(V_1, T_1, S_1, P_1)$ e $G_2=(V_2, T_2, S_2, P_2)$.
Poniamo allora $V^\prime_2$ il *name refreshing* di $V_2$ per evitare nomi uguali nei non terminali di $V_1$.
Possiamo allora costruire: $$G_3=(V_1 \cup V^\prime_2 \cup \{S\}, T_1 \cup T_2, S, P_1 \cup P^\prime_2 \cup \{S \to S_1|S^\prime_2\})$$
dove:
* $S$ è un nuovo simbolo non in $V_1 \cup V^\prime_2$.
* $S^\prime_2$ è il refresh di $S_2$.
* $P^\prime_2$ è il refresh delle produzioni di $P_2$.
Allora $L(G_3)$ è un linguaggio libero e $L(G_3) = L(G_1) \cup L(G_2)$.

Però perchè $G_3$ è libero?
Le produzioni di $G_3 \in \{ P_1 \cup P^\prime_2 \cup \{S \to S_1 | S^\prime_2\}\}$, le produzioni di $P_1$ e $P^\prime_2$ hanno la stessa forma che avevano prima del refreshing dei nomi, quindi la forma $A \to \alpha$.
Quindi le produzioni $S_3 \to S_1$ e $S \to S^\prime_2$ hanno la forma $A \to \alpha$.

Ci rimane da dimostrare perchè $L(G_3) = L(G_1) \cup L(G_2)$?
Poniamo $w \in L(G_3)$ che può esistere se e solo se $S \implies w$ oppure:
$$S \implies S_1 \implies^* w \hspace{3em} \text{oppure} \hspace{3em} S \implies S^\prime_2 \implies^* w$$
Quindi $$w \in L(G_1) \hspace{3em} \text{oppure} \hspace{3em} w \in L(G_2)$$
Posso quindi concludere dicendo che:
$$w \in L(G_1) \cup L(G_2)$$
### Esempio
$$G_1: \begin{cases} S_1 \to aA \\ A \to a \end{cases}$$
$$G_2: \begin{cases} S_2 \to bA \\ A \to b \end{cases}$$
Allora $L(G_1)=\{aa\}$ e $L(G_2)=\{bb\}$.
Facendo il *name refresh* di $G_2$, $A$ diventa $A^\prime$, posso quindi creare l'unione delle grammatiche. 
$$G_3: \begin{cases} S \to S_1|S_2\\ S_1 \to aA\\ S_2 \to bA^\prime\\ A \to a\\ A^\prime \to b \end{cases}$$
Possiamo ora vedere che $L(G_3) = \{aa,\ bb\} = \{aa\} \cup \{bb\} = L(G_1) \cup L(G_2)$ .
## Concatenazione
### Lemma
La classe dei linguaggi liberi è chiusa rispetto alla concatenazione, quindi se $L_1$ e $L_2$ sono linguaggi liberi allora $\{w_1 w_2 | w_1 \in L_1 \land w_2 \in L_2\}$ è un linguaggio libero.
### Dimostrazione
